/**
 * Learning Plan Management API
 * CRUD operations for personalized learning plans with smart topic prioritization
 */

import { loadPrompt } from '../utils/promptEngine.js'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
}

export async function onRequestPost(context) {
  try {
    const body = await context.request.json()
    const { action, userId, planId, planData, apiKey } = body

    if (!userId) {
      return new Response(
        JSON.stringify({ success: false, error: 'User ID required' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    switch (action) {
      case 'create':
        return await createLearningPlan(userId, planData)

      case 'update':
        return await updateLearningPlan(userId, planId, planData)

      case 'delete':
        return await deleteLearningPlan(userId, planId)

      case 'get':
        return await getLearningPlan(userId, planId)

      case 'list':
        return await listLearningPlans(userId)

      case 'prioritize':
        return await prioritizeTopics(userId, planData, apiKey)

      case 'update-progress':
        return await updatePlanProgress(userId, planId, planData)

      default:
        return new Response(
          JSON.stringify({ success: false, error: 'Invalid action' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )
    }
  } catch (error) {
    console.error('Learning plan error:', error)
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
}

export async function onRequestOptions() {
  return new Response(null, { headers: corsHeaders })
}

async function createLearningPlan(userId, planData) {
  const plan = {
    id: crypto.randomUUID(),
    userId,
    name: planData.name || 'Mein Lernplan',
    goals: planData.goals || [],
    selectedTopics: planData.selectedTopics || [],
    smartLearningEnabled: planData.smartLearningEnabled ?? false,
    targetDate: planData.targetDate || null,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    isActive: true,
    progress: {
      totalTopics: planData.selectedTopics?.length || 0,
      completedTopics: 0,
      avgAccuracy: 0,
      totalQuestions: 0,
      correctAnswers: 0,
      totalXpEarned: 0,
    },
    sessions: [],
    metadata: {
      gradeLevel: planData.gradeLevel || 'Klasse_11',
      courseType: planData.courseType || 'Leistungskurs',
    }
  }

  return new Response(
    JSON.stringify({
      success: true,
      plan,
      message: 'Lernplan erfolgreich erstellt'
    }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
}

async function updateLearningPlan(userId, planId, updates) {
  if (!planId) {
    return new Response(
      JSON.stringify({ success: false, error: 'Plan ID required' }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  const updatedPlan = {
    ...updates,
    updatedAt: new Date().toISOString()
  }

  return new Response(
    JSON.stringify({
      success: true,
      plan: updatedPlan,
      message: 'Lernplan aktualisiert'
    }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
}

async function deleteLearningPlan(userId, planId) {
  if (!planId) {
    return new Response(
      JSON.stringify({ success: false, error: 'Plan ID required' }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  return new Response(
    JSON.stringify({
      success: true,
      message: 'Lernplan gelöscht'
    }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
}

async function getLearningPlan(userId, planId) {
  if (!planId) {
    return new Response(
      JSON.stringify({ success: false, error: 'Plan ID required' }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  // In real implementation, fetch from Firestore
  return new Response(
    JSON.stringify({
      success: true,
      plan: null // Will be fetched from Firestore by Flutter app
    }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
}

async function listLearningPlans(userId) {
  // In real implementation, fetch from Firestore
  return new Response(
    JSON.stringify({
      success: true,
      plans: [] // Will be fetched from Firestore by Flutter app
    }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
}

async function prioritizeTopics(userId, planData, apiKey) {
  if (!apiKey) {
    // Fallback: Simple prioritization without AI
    const prioritized = prioritizeTopicsSimple(planData)
    return new Response(
      JSON.stringify({ success: true, prioritizedTopics: prioritized }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  try {
    // Build prompt for AI topic prioritization
    const topicsText = planData.selectedTopics
      .map(t => `${t.leitidee} > ${t.thema} > ${t.unterthema}`)
      .join('\n')

    const performanceText = planData.topicProgress
      ? Object.entries(planData.topicProgress)
          .map(([topic, stats]) => `${topic}: ${stats.accuracy}% Genauigkeit, ${stats.attempts} Versuche`)
          .join('\n')
      : 'Keine bisherigen Leistungsdaten'

    const prompt = `Du bist ein Lern-Assistent. Priorisiere die folgenden Themen basierend auf Schwierigkeitsgrad und bisheriger Leistung.

AUSGEWÄHLTE THEMEN:
${topicsText}

BISHERIGE LEISTUNG:
${performanceText}

Erstelle eine priorisierte Liste der Themen, bei denen der Schüler am meisten Unterstützung benötigt.
Antworte im JSON-Format:
{
  "prioritizedTopics": [
    {
      "topic": "Leitidee > Thema > Unterthema",
      "priority": 1-5,
      "reason": "Begründung für die Priorisierung"
    }
  ],
  "recommendations": "Gesamtempfehlung für den Lernplan"
}`

    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01'
      },
      body: JSON.stringify({
        model: 'claude-sonnet-4-20250514',
        max_tokens: 2000,
        temperature: 0.5,
        messages: [{ role: 'user', content: prompt }]
      })
    })

    if (!response.ok) {
      throw new Error('AI API error')
    }

    const data = await response.json()
    const content = data.content[0].text

    // Parse JSON response
    const jsonMatch = content.match(/\{[\s\S]*\}/)
    const parsed = jsonMatch ? JSON.parse(jsonMatch[0]) : { prioritizedTopics: [], recommendations: '' }

    return new Response(
      JSON.stringify({
        success: true,
        prioritizedTopics: parsed.prioritizedTopics,
        recommendations: parsed.recommendations
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('AI prioritization error:', error)
    // Fallback to simple prioritization
    const prioritized = prioritizeTopicsSimple(planData)
    return new Response(
      JSON.stringify({ success: true, prioritizedTopics: prioritized }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
}

function prioritizeTopicsSimple(planData) {
  const topics = planData.selectedTopics || []
  const progress = planData.topicProgress || {}

  return topics.map(topic => {
    const topicKey = `${topic.leitidee}_${topic.thema}_${topic.unterthema}`
    const stats = progress[topicKey] || { accuracy: 0, attempts: 0 }

    // Priority based on low accuracy and few attempts
    let priority = 3 // Medium by default
    if (stats.accuracy < 50 && stats.attempts > 0) priority = 5 // High priority
    else if (stats.accuracy < 70 && stats.attempts > 0) priority = 4
    else if (stats.attempts === 0) priority = 3 // New topics
    else if (stats.accuracy > 80) priority = 1 // Low priority (already good)
    else priority = 2

    return {
      topic: `${topic.leitidee} > ${topic.thema} > ${topic.unterthema}`,
      priority,
      reason: stats.attempts === 0
        ? 'Noch nicht gelernt'
        : stats.accuracy < 50
        ? 'Niedrige Genauigkeit - mehr Übung erforderlich'
        : stats.accuracy > 80
        ? 'Bereits gut beherrscht'
        : 'Weitere Übung empfohlen'
    }
  }).sort((a, b) => b.priority - a.priority)
}

async function updatePlanProgress(userId, planId, progressData) {
  if (!planId) {
    return new Response(
      JSON.stringify({ success: false, error: 'Plan ID required' }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  const updatedProgress = {
    ...progressData,
    updatedAt: new Date().toISOString()
  }

  return new Response(
    JSON.stringify({
      success: true,
      progress: updatedProgress,
      message: 'Fortschritt aktualisiert'
    }),
    { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
  )
}
