import * as rtdb from "../core/rtdb.repository";

export async function getGroupConfig(groupId: string): Promise<unknown | null> {
    return rtdb.getGroupConfig(groupId);
}

export async function updateGroupConfig(groupId: string, config: Record<string, unknown>): Promise<void> {
    await rtdb.updateGroupConfig(groupId, config);
}
