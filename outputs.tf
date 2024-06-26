# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "pubsub_topics" {
  description = "The list of Pub/Sub topics created."
  value       = [for topic in google_pubsub_topic.pubsub_topic : topic.name]
}


output "pull_pubsub_subscriptions" {
  description = "The list of Pub/Sub subscriptions created."
  value       = [for subscription in google_pubsub_subscription.pull_subscriptions : subscription.name]
}


output "push_pubsub_subscriptions" {
  description = "The list of Pub/Sub subscriptions created."
  value       = [for subscription in google_pubsub_subscription.push_subscriptions : subscription.name]
}