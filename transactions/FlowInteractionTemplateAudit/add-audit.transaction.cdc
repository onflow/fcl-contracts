import FlowInteractionTemplateAudit from 0xFlowInteractionTemplateAudit

transaction(templateId: String) {
  let flowInteractionTemplateAuditManagerPrivateRef: &FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPrivate}

  prepare(account: AuthAccount) {
    if account.borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager>(from: FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerStoragePath) == nil {
      let FlowInteractionTemplateAuditManager <- FlowInteractionTemplateAudit.createFlowInteractionTemplateAuditManager()

      account.save(
        <- FlowInteractionTemplateAuditManager, 
        to: FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerStoragePath,
      )
            
      account.link<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublic}>(
        FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublicPath,
        target: FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerStoragePath
      )

      account.link<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPrivate}>(
        FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPrivatePath,
        target: FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerStoragePath
      )
    }

    self.FlowInteractionTemplateAuditManagerPrivateRef = 
      account.borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPrivate}>(from: FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerStoragePath)
        ?? panic("Could not borrow ref to FlowInteractionTemplateAuditManagerPrivate")
  }

  execute {
    self.FlowInteractionTemplateAuditManagerPrivateRef.addAudit(templateId: templateId)
  }
}