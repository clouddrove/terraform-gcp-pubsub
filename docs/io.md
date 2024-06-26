## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_subscriptions | Specify true if you want to create subscriptions. | `bool` | `true` | no |
| create\_topic | Specify true if you want to create a topic. | `bool` | `true` | no |
| message\_storage\_policy | A map of storage policies. Default - inherit from organization's Resource Location Restriction policy. | `map(any)` | `{}` | no |
| project\_id | The project ID to manage the Pub/Sub resources. | `string` | n/a | yes |
| pull\_subscription\_iam\_binding | Flag to create IAM binding for Pub/Sub pull subscription | `bool` | `false` | no |
| pull\_subscription\_roles\_members | List of roles and members for pull subscriptions | <pre>list(object({<br>    role   = string<br>    member = string<br>  }))</pre> | `[]` | no |
| pull\_subscriptions | The list of the pull subscriptions. | `list(map(string))` | `[]` | no |
| push\_subscription\_iam\_binding | Flag to create IAM binding for Pub/Sub push subscription | `bool` | `false` | no |
| push\_subscription\_roles\_members | List of roles and members for push subscriptions | <pre>list(object({<br>    role   = string<br>    member = string<br>  }))</pre> | `[]` | no |
| push\_subscriptions | The list of the push subscriptions. | `list(map(string))` | `[]` | no |
| schema | Schema for the topic. | <pre>object({<br>    name       = string<br>    type       = string<br>    definition = string<br>    encoding   = string<br>  })</pre> | `null` | no |
| subscription\_labels | A map of labels to assign to every Pub/Sub subscription. | `map(string)` | `{}` | no |
| topic | The Pub/Sub topic name. | `string` | `"my-pubsub"` | no |
| topic\_iam\_binding | Flag to create IAM binding for Pub/Sub topic | `bool` | `false` | no |
| topic\_iam\_binding\_roles\_members | List of roles and members for topic | <pre>list(object({<br>    role   = string<br>    member = string<br>  }))</pre> | `[]` | no |
| topic\_kms\_key\_name | The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic. | `string` | `null` | no |
| topic\_labels | A map of labels to assign to the Pub/Sub topic. | `map(string)` | `{}` | no |
| topic\_message\_retention\_duration | The minimum duration in seconds to retain a message after it is published to the topic. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| pubsub\_topics | The list of Pub/Sub topics created. |
| pull\_pubsub\_subscriptions | The list of Pub/Sub subscriptions created. |
| push\_pubsub\_subscriptions | The list of Pub/Sub subscriptions created. |

