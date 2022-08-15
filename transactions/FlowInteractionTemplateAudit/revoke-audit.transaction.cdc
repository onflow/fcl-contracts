import FlowInteractionTemplateAudit from 0xFlowInteractionTemplateAudit

transaction(templateId: String) {
  let FlowInteractionTemplateAuditManagerPrivateRef: &FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPrivate}

  prepare(account: AuthAccount) {
    self.FlowInteractionTemplateAuditManagerPrivateRef = 
      account.borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPrivate}>(from: FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerStoragePath)
        ?? panic("Could not borrow ref to FlowInteractionTemplateAuditManagerPrivate")
  }

  execute {
    self.FlowInteractionTemplateAuditManagerPrivateRef.revokeAudit(templateId: templateId)
  }
}