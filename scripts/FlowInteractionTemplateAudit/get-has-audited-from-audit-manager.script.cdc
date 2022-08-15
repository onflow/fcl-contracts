import FlowInteractionTemplateAudit from 0xFlowInteractionTemplateAudit

pub fun main(auditor: Address, templateId: String): Bool {
  let auditManagerRef = getAccount(account)
    .getCapability(FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublicPath)
    .borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublic}>()
    ?? panic("Could not borrow Audit Manager public reference")

  return auditManagerRef.getHasAuditedTemplate(templateId: templateId)
}