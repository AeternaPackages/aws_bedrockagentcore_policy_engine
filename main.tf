locals {
  bedrockagentcore_policy_engines = { for k1, v1 in var.bedrockagentcore_policy_engines : k1 => { description = v1.description, encryption_key_arn = v1.encryption_key_arn, name = v1.name, region = v1.region, tags = v1.tags } }

  bedrockagentcore_policies = merge([
    for k1, v1 in var.bedrockagentcore_policy_engines : {
      for k2, v2 in coalesce(v1.bedrockagentcore_policies, {}) :
      "${k1}/${k2}" => merge(v2, {
        policy_engine_id = module.bedrockagentcore_policy_engines.bedrockagentcore_policy_engines_policy_engine_id["${k1}"]
      })
    }
  ]...)
}

module "bedrockagentcore_policy_engines" {
  source                          = "git::https://github.com/AeternaModules/aws_bedrockagentcore_policy_engine.git?ref=v6.58.0"
  bedrockagentcore_policy_engines = local.bedrockagentcore_policy_engines
}

module "bedrockagentcore_policies" {
  source                    = "git::https://github.com/AeternaModules/aws_bedrockagentcore_policy.git?ref=v6.58.0"
  bedrockagentcore_policies = local.bedrockagentcore_policies
  depends_on                = [module.bedrockagentcore_policy_engines]
}

