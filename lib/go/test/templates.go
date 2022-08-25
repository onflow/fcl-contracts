package test

import (
	"regexp"

	"github.com/onflow/flow-go-sdk"
)

type Contracts struct {
	FCLCrypto                    flow.Address
	FlowInteractionTemplateAudit flow.Address
}

var fclCryptoPlaceholder = regexp.MustCompile(`"[^"\s].*/FCLCrypto.cdc"`)
var flowInteractionTemplatePlaceholder = regexp.MustCompile(`"[^"\s].*/FlowInteractionTemplateAudit.cdc"`)

const (
	fclCryptoPath                                 = "../../../cadence/contracts/FCLCrypto.cdc"
	scriptsRootPath                               = "../../../cadence/scripts"
	transactionsRootPath                          = "../../../cadence/transactions"
	flowInteractionTemplatePath                   = "../../../cadence/contracts/FlowInteractionTemplateAudit.cdc"
	flowCreateInteractionTemplateAuditManagerPath = transactionsRootPath + "/FlowInteractionTemplateAudit/create-audit-manager.transaction.cdc"
	flowAddInteractionTemplateAuditPath           = transactionsRootPath + "/FlowInteractionTemplateAudit/add-audit.transaction.cdc"
	flowRevokeInteractionTemplateAuditPath        = transactionsRootPath + "/FlowInteractionTemplateAudit/revoke-audit.transaction.cdc"
	flowHasAuditedInteractionTemplateAuditPath    = scriptsRootPath + "/FlowInteractionTemplateAudit/get-has-audited-from-audit-manager.script.cdc"
	verifyUserSignaturesPath                      = scriptsRootPath + "/FCLCrypto/verifyUserSignatures.cdc"
	verifyAccountProofSignaturesPath              = scriptsRootPath + "/FCLCrypto/verifyAccountProofSignatures.cdc"
)

func replaceAddresses(codeBytes []byte, contracts Contracts) []byte {
	code := string(codeBytes)

	code = fclCryptoPlaceholder.ReplaceAllString(code, "0x"+contracts.FCLCrypto.String())
	code = flowInteractionTemplatePlaceholder.ReplaceAllString(code, "0x"+contracts.FlowInteractionTemplateAudit.String())

	return []byte(code)
}

func fclCryptoContract() []byte {
	return readFile(fclCryptoPath)
}

func flowInteractionTemplateContract() []byte {
	return readFile(flowInteractionTemplatePath)
}

func flowCreateInteractionTemplateAuditManagerScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(flowCreateInteractionTemplateAuditManagerPath),
		contracts,
	)
}

func flowAddInteractionTemplateAuditScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(flowAddInteractionTemplateAuditPath),
		contracts,
	)
}

func flowRevokeInteractionTemplateAuditScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(flowRevokeInteractionTemplateAuditPath),
		contracts,
	)
}

func flowHasAuditedInteractionTemplateAudit(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(flowHasAuditedInteractionTemplateAuditPath),
		contracts,
	)
}

func verifyUserSignaturesScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(verifyUserSignaturesPath),
		contracts,
	)
}

func verifyAccountProofSignaturesScript(contracts Contracts) []byte {
	return replaceAddresses(
		readFile(verifyAccountProofSignaturesPath),
		contracts,
	)
}
