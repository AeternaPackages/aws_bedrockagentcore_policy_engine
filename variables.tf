variable "bedrockagentcore_policy_engines" {
  description = <<EOT
Map of bedrockagentcore_policy_engines, attributes below
Required:
    - name
Optional:
    - description
    - encryption_key_arn
    - region
    - tags
Nested bedrockagentcore_policies (aws_bedrockagentcore_policy):
    Required:
        - name
    Optional:
        - description
        - region
        - validation_mode
        - definition (block)
EOT

  type = map(object({
    name               = string
    description        = optional(string)
    encryption_key_arn = optional(string)
    region             = optional(string)
    tags               = optional(map(string))
    bedrockagentcore_policies = optional(map(object({
      name            = string
      description     = optional(string)
      region          = optional(string)
      validation_mode = optional(string)
      definition = optional(list(object({
        cedar = optional(list(object({
          statement = string
        })))
      })))
    })))
  }))

  validation {
    condition = alltrue(concat(
      [for kk in keys(var.bedrockagentcore_policy_engines) : !strcontains(kk, "/")],
      flatten([for k0, v0 in var.bedrockagentcore_policy_engines : [for kk in keys(coalesce(v0.bedrockagentcore_policies, {})) : !strcontains(kk, "/")]])
    ))
    error_message = "Map keys in this package must not contain '/': it is used internally as a nesting-key separator, so a key containing it can silently collide two different nested entries into one. Rename the offending key(s)."
  }
}
