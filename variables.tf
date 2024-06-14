# variables.tf

variable "project_id" {
  type        = string
  description = "The project ID to manage the Pub/Sub resources."
}

variable "topic" {
  type        = string
  description = "The Pub/Sub topic name."
  default     = "my-pubsub"
}

variable "create_topic" {
  type        = bool
  description = "Specify true if you want to create a topic."
  default     = true
}

variable "create_pull_subscriptions" {
  description = "Whether to create pull subscriptions"
  default     = false
}


variable "pull_subscription_ttl" {
  description = "Time-to-live for pull subscriptions"
  default     = "10m"
}

variable "pull_subscription_dead_letter_topic" {
  description = "Dead letter topic for pull subscriptions"
}

variable "create_push_subscriptions" {
  description = "Whether to create push subscriptions"
  default     = false
}
variable "create_subscriptions" {
  type        = bool
  description = "Specify true if you want to create subscriptions."
  default     = true
}

variable "push_subscription_dead_letter_topic" {
  description = "Dead letter topic for push subscriptions"
}

variable "push_subscriptions" {
  type        = list(map(string))
  description = "The list of the push subscriptions."
  default     = []
}

variable "pull_subscriptions" {
  type        = list(map(string))
  description = "The list of the pull subscriptions."
  default     = []
}

variable "topic_kms_key_name" {
  type        = string
  description = "The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic."
  default     = null
}

variable "schema" {
  type = object({
    name       = string
    type       = string
    definition = string
    encoding   = string
  })
  description = "Schema for the topic."
  default     = null
}


variable "subscription_labels" {
  type        = map(string)
  description = "A map of labels to assign to every Pub/Sub subscription."
  default     = {}
}




