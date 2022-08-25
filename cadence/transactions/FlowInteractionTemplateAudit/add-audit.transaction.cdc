import FlowInteractionTemplateAudit from "./contracts/FlowInteractionTemplateAudit.cdc"

transaction(templateId: String) {
  let flowInteractionTemplateAuditManagerPrivateRef: &FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPrivate}
  // let flowInteractionTemplateAuditManagerPublicRef:  &FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublic}

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

    // self.flowInteractionTemplateAuditManagerPublicRef = 
    //   account.borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublic}>(from: FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublicPath)
    //     ?? panic("Could not borrow ref to FlowInteractionTemplateAuditManagerPrivate")

    let auditManagerRef = account
    .getCapability(FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublicPath)
    .borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublic}>()
    ?? panic("Could not borrow Audit Manager public reference")

    self.flowInteractionTemplateAuditManagerPrivateRef = 
      account.borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPrivate}>(from: FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerStoragePath)
        ?? panic("Could not borrow ref to FlowInteractionTemplateAuditManagerPrivate")
  }

  execute {
    self.flowInteractionTemplateAuditManagerPrivateRef.addAudit(templateId: templateId)
  }
}