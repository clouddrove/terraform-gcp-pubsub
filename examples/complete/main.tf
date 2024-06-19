
# ------------------------------------------------------------------------------
# Module
# ------------------------------------------------------------------------------

module "pubsub" {
  source = "../../"

  project_id           = "my-project-44865-424207"
  topic                = "topic-2"
  create_topic         = true
  create_subscriptions = true
  topic_kms_key_name   = ""
  topic_iam_binding    = false
  topic_iam_binding_roles_members = [
    {
      role   = "roles/pubsub.subscriber"
      member = "user:example@example.com"
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
      member = "user:example@example.com"
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