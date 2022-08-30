import path from "path";
import {
  init,
  emulator,
  shallPass,
  sendTransaction,
  getAccountAddress,
  deployContractByName,
  createAccount,
  executeScript,
} from "@onflow/flow-js-testing";

const CADENCE_PATH = "../../../cadence";

const TXID_1 = "txid1";
const TXID_2 = "txid2";

const getHasAuditedFromAuditManagerScriptName =
  "FlowInteractionTemplateAudit/get-has-audited-from-audit-manager.script";
const getAuditsFromAuditManagerScriptName =
  "FlowInteractionTemplateAudit/get-audits-from-audit-manager.script";
const addAuditTransactionName =
  "FlowInteractionTemplateAudit/add-audit.transaction";
const createAuditManagerTransactionName =
  "FlowInteractionTemplateAudit/create-audit-manager.transaction";
const revokeAuditManagerTransactionName =
  "FlowInteractionTemplateAudit/revoke-audit.transaction";

describe("interactions - sendTransaction", () => {
  beforeEach(async () => {
    const basePath = path.resolve(__dirname, CADENCE_PATH);
    await init(basePath);
    await emulator.start();
    const to = await getAccountAddress("Alice");
    const contractName = "FlowInteractionTemplateAudit";

    const [deploymentResult, error] = await deployContractByName({
      to,
      name: contractName,
    });
    return;
  });

  afterEach(async () => {
    await emulator.stop();
    return;
  });

  test("add audit", async () => {
    const Alice = await getAccountAddress("Alice");

    const [tx, error] = await shallPass(
      sendTransaction({
        name: addAuditTransactionName,
        args: [TXID_1],
        signers: [Alice],
      })
    );

    const [result1, e1] = await executeScript({
      name: getHasAuditedFromAuditManagerScriptName,
      args: [Alice, TXID_1],
    });

    expect(result1).toBe(true);

    const [result2, e2] = await executeScript({
      name: getHasAuditedFromAuditManagerScriptName,
      args: [Alice, TXID_2],
    });

    expect(result2).toBe(false);

    const [tx2, error2] = await shallPass(
      sendTransaction({
        name: addAuditTransactionName,
        args: [TXID_2],
        signers: [Alice],
      })
    );

    const [result3, e3] = await executeScript({
      name: getHasAuditedFromAuditManagerScriptName,
      args: [Alice, TXID_2],
    });

    expect(result3).toBe(true);
  });

  test("get audits", async () => {
    const Alice = await getAccountAddress("Alice");

    const [tx, error] = await shallPass(
      sendTransaction({
        name: createAuditManagerTransactionName,
        args: [],
        signers: [Alice],
      })
    );

    const [result, e] = await executeScript({
      name: getAuditsFromAuditManagerScriptName,
      args: [Alice],
    });

    expect(result.length).toBe(0);

    const [tx2, error2] = await shallPass(
      sendTransaction({
        name: addAuditTransactionName,
        args: [TXID_1],
        signers: [Alice],
      })
    );

    const [result2, e2] = await executeScript({
      name: getAuditsFromAuditManagerScriptName,
      args: [Alice],
    });

    expect(result2.length).toBe(1);
    expect(result2[0]).toBe(TXID_1);
  });

  test("create audit manager", async () => {
    const Alice = await getAccountAddress("Alice");

    const [tx, error] = await shallPass(
      sendTransaction({
        name: createAuditManagerTransactionName,
        args: [],
        signers: [Alice],
      })
    );

    const [result, e] = await executeScript({
      name: getAuditsFromAuditManagerScriptName,
      args: [Alice],
    });

    expect(result.length).toBe(0);
  });

  test("revoke audit", async () => {
    const Alice = await getAccountAddress("Alice");

    const [tx, error] = await shallPass(
      sendTransaction({
        name: addAuditTransactionName,
        args: [TXID_1],
        signers: [Alice],
      })
    );

    const [result, e] = await executeScript({
      name: getHasAuditedFromAuditManagerScriptName,
      args: [Alice, TXID_1],
    });

    expect(result).toBe(true);

    const [tx2, error2] = await shallPass(
      sendTransaction({
        name: revokeAuditManagerTransactionName,
        args: [TXID_1],
        signers: [Alice],
      })
    );

    const [result2, e2] = await executeScript({
      name: getHasAuditedFromAuditManagerScriptName,
      args: [Alice, TXID_1],
    });

    expect(result2).toBe(false);
  });
});
