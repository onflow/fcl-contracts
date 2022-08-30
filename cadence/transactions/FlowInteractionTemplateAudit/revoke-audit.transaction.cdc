import FlowInteractionTemplateAudit from "./contracts/FlowInteractionTemplateAudit.cdc"

transaction(templateId: String) {
  let FlowInteractionTemplateAuditManagerPrivateRef: &FlowInteractionTemplateAudit.AuditManager{FlowInteractionTemplateAudit.AuditManagerPrivate}

  prepare(account: AuthAccount) {
    self.FlowInteractionTemplateAuditManagerPrivateRef = 
      account.borrow<&FlowInteractionTemplateAudit.AuditManager{FlowInteractionTemplateAudit.AuditManagerPrivate}>(from: FlowInteractionTemplateAudit.AuditManagerStoragePath)
        ?? panic("Could not borrow ref to AuditManagerPrivate")
  }

  execute {
    self.FlowInteractionTemplateAuditManagerPrivateRef.revokeAudit(templateId: templateId)
  }
}