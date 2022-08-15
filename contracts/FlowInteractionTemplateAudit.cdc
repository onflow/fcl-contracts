pub contract FlowInteractionTemplateAudit {

  pub event AuditAdded(templateId: String, auditor: Address)
  pub event AuditRevoked(templateId: String, auditor: Address)
  pub event AuditorCreated()

  pub let FlowInteractionTemplateAuditManagerStoragePath: StoragePath
  pub let FlowInteractionTemplateAuditManagerPublicPath: PublicPath
  pub let FlowInteractionTemplateAuditManagerPrivatePath: PrivatePath

  pub resource interface FlowInteractionTemplateAuditManagerPublic {
    pub fun getAudits(): [String]
    pub fun getHasAuditedTemplate(templateId: String): Bool
  }

  pub resource interface FlowInteractionTemplateAuditManagerPrivate {
    pub fun addAudit(templateId: String)
    pub fun revokeAudit(templateId: String)
  }

  pub resource FlowInteractionTemplateAuditManager: FlowInteractionTemplateAuditManagerPublic, FlowInteractionTemplateAuditManagerPrivate {
    access(self) var audits: {String:Bool}
    
    init() {
      self.audits = {}
      emit AuditorCreated()
    }

    pub fun getAudits(): [String] {
      return self.audits.keys
    }

    pub fun getHasAuditedTemplate(templateId: String): Bool {
      return self.audits.containsKey(templateId)
    }
  
    pub fun addAudit(templateId: String) {
      pre {
        !self.audits.containsKey(templateId): "Cannot audit template that is already audited"
      }
      self.audits.insert(key: templateId, true)
      emit AuditAdded(templateId: templateId, auditor: self.owner?.address!)
    }

    pub fun revokeAudit(templateId: String) {
      pre {
        self.audits.containsKey(templateId): "Cannot revoke audit for a template that is not already audited"
      }
      self.audits.remove(key: templateId)
      emit AuditRevoked(templateId: templateId, auditor: self.owner?.address!)
    }
  }

  pub fun createFlowInteractionTemplateAuditManager(): @FlowInteractionTemplateAuditManager {
    return <- create FlowInteractionTemplateAuditManager()
  }

  pub fun getHasAuditedTemplateByAuditors(templateId: String, auditors: [Address]): {Address:Bool} {
    let audits: {Address:Bool} = {}

    for auditor in auditors {
      let auditManagerRef = getAccount(auditor)
        .getCapability(FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublicPath)
        .borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublic}>()
        ?? panic("Could not borrow Audit Manager public reference")

      audits.insert(key: auditor, auditManagerRef.getHasAuditedTemplate(templateId: templateId))
    }

    return audits
  }

  pub fun getAuditsByAuditor(auditor: Address): [String] {
    let auditManagerRef = getAccount(auditor)
      .getCapability(FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublicPath)
      .borrow<&FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManager{FlowInteractionTemplateAudit.FlowInteractionTemplateAuditManagerPublic}>()
      ?? panic("Could not borrow Audit Manager public reference")

    return auditManagerRef.getAudits()
  }

  init() { 
    self.FlowInteractionTemplateAuditManagerStoragePath = /storage/FlowInteractionTemplateAuditManagerStoragePath
    self.FlowInteractionTemplateAuditManagerPublicPath = /public/FlowInteractionTemplateAuditManagerPublicPath
    self.FlowInteractionTemplateAuditManagerPrivatePath = /private/FlowInteractionTemplateAuditManagerPrivatePath
  }
}