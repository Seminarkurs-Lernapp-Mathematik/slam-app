/**
 * Memories & Spaced Repetition API
 * Implements SuperMemo SM-2 algorithm for optimal review scheduling
 *
 * SM-2 Algorithm:
 * - EF (Ease Factor): Difficulty multiplier (default 2.5)
 * - Interval: Days until next review
 * - Quality: 0-5 rating of recall (0=complete blackout, 5=perfect recall)
 *
 * Intervals:
 * - First review: 1 day
 * - Second review: 6 days
 * - Subsequent: previous interval × EF
 */

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
}

export async function onRequestPost(context) {
  try {
    const body = await context.request.json()
    const { action, userId, memoryId, memoryData, quality } = body

    if (!userId) {
      return new Response(
        JSON.stringify({ success: false, error: 'User ID required' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    switch (action) {
      case 'create':
        return await createMemory(userId, memoryData)

      case 'review':
        return await reviewMemory(userId, memoryId, quality)

      case 'get-due':
        return await getDueReviews(userId)

      case 'get-stats':
        return await getMemoryStats(userId)

      case 'update':
        return await updateMemory(userId, memoryId, memoryData)

      case 'delete':
        return await deleteMemory(userId, memoryId)

      default:
        return new Response(
          JSON.stringify({ success: false, error: 'Invalid action' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )
    }
  } catch (error) {
    console.error('Memories error:', error)
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
}

export async function onRequestOptions() {
  return new Response(null, { headers: corsHeaders })
}

/**
 * Create a new memory from a completed question
 */
async function createMemory(userId, memoryData) {
  const memory = {
    id: crypto.randomUUID(),
    userId,
    questionId: memoryData.questionId,
    questionText: memoryData.questionText,
    topic: memoryData.topic,
    subtopic: memoryData.subtopic,
    leitidee: memoryData.leitidee,
    difficulty: memoryData.difficulty || 3,
    afbLevel: memoryData.afbLevel || 1,

    // SM-2 Algorithm variables
    easeFactor: 2.5, // Default ease factor
    interval: 0, // Will be set after first review
    repetitions: 0, // Number of successful reviews

    // Review tracking
    lastReviewedAt: new Date().toISOString(),
    nextReviewAt: getNextReviewDate(0, 2.5).toISOString(),

    // Statistics
    reviewCount: 0,
    averageQuality: 0,
    lastQuality: null,

    // Review history
    reviewHistory: [],

    // Metadata
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    isArchived: false,
  }

  return new Response(
    JSON.stringify({
      success: true,
      memory,
      message: 'Erinnerung erstellt'
    }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
}

/**
 * Review a memory and update SM-2 parameters
 * @param {number} quality - 0 to 5 rating (0=forgot, 5=perfect)
 */
async function reviewMemory(userId, memoryId, quality) {
  if (!memoryId) {
    return new Response(
      JSON.stringify({ success: false, error: 'Memory ID required' }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  if (quality < 0 || quality > 5) {
    return new Response(
      JSON.stringify({ success: false, error: 'Quality must be 0-5' }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  // This would be fetched from Firestore in real implementation
  // For now, calculate the SM-2 update
  const sm2Result = calculateSM2(quality, 0, 2.5, 0)

  const reviewRecord = {
    reviewedAt: new Date().toISOString(),
    quality,
    easeFactor: sm2Result.easeFactor,
    interval: sm2Result.interval,
    nextReviewAt: sm2Result.nextReviewDate.toISOString(),
    repetitions: sm2Result.repetitions,
  }

  return new Response(
    JSON.stringify({
      success: true,
      review: reviewRecord,
      message: quality >= 3 ? 'Gut gemacht!' : 'Weiter üben!',
      shouldRepeat: quality < 3, // If quality < 3, should review again soon
    }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
}

/**
 * SuperMemo SM-2 Algorithm Implementation
 *
 * @param {number} quality - 0 to 5 (user's recall quality)
 * @param {number} repetitions - Number of consecutive successful reviews
 * @param {number} easeFactor - Current ease factor (EF)
 * @param {number} interval - Current interval in days
 * @returns {object} Updated SM-2 parameters
 */
function calculateSM2(quality, repetitions, easeFactor, interval) {
  // Calculate new ease factor
  let newEaseFactor = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))

  // EF cannot be less than 1.3
  if (newEaseFactor < 1.3) {
    newEaseFactor = 1.3
  }

  let newRepetitions = repetitions
  let newInterval = interval

  if (quality < 3) {
    // Incorrect recall - reset repetitions and interval
    newRepetitions = 0
    newInterval = 1 // Review again tomorrow
  } else {
    // Correct recall - increase repetitions and interval
    newRepetitions = repetitions + 1

    if (newRepetitions === 1) {
      newInterval = 1 // First review: 1 day
    } else if (newRepetitions === 2) {
      newInterval = 6 // Second review: 6 days
    } else {
      // Subsequent reviews: multiply by ease factor
      newInterval = Math.round(interval * newEaseFactor)
    }
  }

  const nextReviewDate = getNextReviewDate(newInterval, newEaseFactor)

  return {
    easeFactor: newEaseFactor,
    repetitions: newRepetitions,
    interval: newInterval,
    nextReviewDate,
  }
}

/**
 * Calculate next review date
 */
function getNextReviewDate(intervalDays, easeFactor) {
  const now = new Date()
  const nextDate = new Date(now)
  nextDate.setDate(now.getDate() + intervalDays)
  return nextDate
}

/**
 * Get all memories due for review
 */
async function getDueReviews(userId) {
  const now = new Date().toISOString()

  // In real implementation, query Firestore:
  // WHERE nextReviewAt <= now AND isArchived == false
  // ORDER BY nextReviewAt ASC

  return new Response(
    JSON.stringify({
      success: true,
      dueReviews: [], // Will be fetched from Firestore by Flutter app
      count: 0,
    }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
}

/**
 * Get memory statistics
 */
async function getMemoryStats(userId) {
  // In real implementation, aggregate from Firestore
  const stats = {
    totalMemories: 0,
    dueToday: 0,
    dueThisWeek: 0,
    reviewedToday: 0,
    averageRetention: 0,
    longestStreak: 0,
    currentStreak: 0,
    byTopic: {},
    byDifficulty: {
      easy: 0,
      medium: 0,
      hard: 0,
    },
    recentReviews: [],
  }

  return new Response(
    JSON.stringify({
      success: true,
      stats,
    }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
}

/**
 * Update a memory (e.g., archive, modify)
 */
async function updateMemory(userId, memoryId, updates) {
  if (!memoryId) {
    return new Response(
      JSON.stringify({ success: false, error: 'Memory ID required' }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  const updatedMemory = {
    ...updates,
    updatedAt: new Date().toISOString()
  }

  return new Response(
    JSON.stringify({
      success: true,
      memory: updatedMemory,
      message: 'Erinnerung aktualisiert'
    }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
}

/**
 * Delete a memory
 */
async function deleteMemory(userId, memoryId) {
  if (!memoryId) {
    return new Response(
      JSON.stringify({ success: false, error: 'Memory ID required' }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  return new Response(
    JSON.stringify({
      success: true,
      message: 'Erinnerung gelöscht'
    }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
}

/**
 * Helper: Get quality from answer correctness and hints used
 */
export function getQualityFromPerformance(isCorrect, hintsUsed, timeSpent, expectedTime) {
  if (!isCorrect) {
    // Incorrect answer
    if (hintsUsed >= 3) return 0 // Complete blackout
    if (hintsUsed === 2) return 1 // Severe difficulty
    return 2 // Wrong but remembered something
  }

  // Correct answer
  if (hintsUsed === 0 && timeSpent < expectedTime * 0.5) return 5 // Perfect recall, fast
  if (hintsUsed === 0) return 4 // Correct with hesitation
  if (hintsUsed === 1) return 3 // Correct with difficulty
  return 2 // Correct but with much difficulty
}
