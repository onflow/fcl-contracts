import FlowInteractionTemplateAudit from "./contracts/FlowInteractionTemplateAudit.cdc"

pub fun main(auditor: Address): [String] {
  let auditManagerRef = getAccount(auditor)
    .getCapability(FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublicPath)
    .borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublic}>()
    ?? panic("Could not borrow Audit Manager public reference")

  return auditManagerRef.getAudits()
}