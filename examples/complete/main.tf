
# ------------------------------------------------------------------------------
# GCP Pub/Sub Module Configuration for Pull Subscription
# ------------------------------------------------------------------------------

module "pubsub" {
  source = "../../"

  project_id           = "clouddrove-1"
  topic                = "topic-2"
  create_topic         = true
  create_subscriptions = true
  topic_kms_key_name   = "example_key_2"
  topic_iam_binding    = false
  topic_iam_binding_roles_members = [
    {
      role   = "roles/pubsub.subscriber"
      member = "group:example@example.com"
    },
    {
      role   = "roles/pubsub.viewer"
      member = "serviceAccount:example@example.gserviceaccount.com"
    }
  ]
  pull_subscription_iam_binding = false
  pull_subscription_roles_members = [
    {
      role   = "roles/pubsub.subscriber"
      member = "group:example@example.com"
    },
    {
      role   = "roles/pubsub.viewer"
      member = "serviceAccount:example@example.gserviceaccount.com"
    }
  ]
  pull_subscriptions = [
    {
      name                         = "pull"
      ack_deadline_seconds         = 10
      enable_exactly_once_delivery = true
    },
  ]
}