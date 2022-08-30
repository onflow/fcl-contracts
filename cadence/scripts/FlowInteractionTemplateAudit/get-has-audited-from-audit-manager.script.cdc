import FlowInteractionTemplateAudit from "./contracts/FlowInteractionTemplateAudit.cdc"

pub fun main(auditor: Address, templateId: String): Bool {
  let auditManagerRef = getAccount(auditor)
    .getCapability(FlowInteractionTemplateAudit.AuditManagerPublicPath)
    .borrow<&FlowInteractionTemplateAudit.AuditManager{FlowInteractionTemplateAudit.AuditManagerPublic}>()
    ?? panic("Could not borrow Audit Manager public reference")

  return auditManagerRef.getHasAuditedTemplate(templateId: templateId)
}