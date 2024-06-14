# main.tf
locals {
  project_id = "my-project-44865-424207"
}

provider "google" {
  region = "us-central1"
}


module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 6.0"

  project_id           = local.project_id
  create_topic         = true
  topic = "dffv"
  create_subscriptions = true
  # topic                = google_pubsub_topic.example.id

  # token_creator_binding = false

  pull_subscriptions = [
    {
      name                 = "pull"
      ack_deadline_seconds = 10
    },
  ]


  #   push_subscriptions = [
  #   {
  #     name                 = "push"
  #     push_endpoint        = "https://${local.project_id}.appspot.com/"
  #     x-goog-version       = "v1beta1"
  #     ack_deadline_seconds = 20
  #     expiration_policy    = "1209600s" // two weeks
  #   },
  # ]

}