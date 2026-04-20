/**
* @brief   Test the EntityArray special array type.
* @details
* @authors Orsell
*
* @license Distributed under the MIT license - Copyright (c) 2026 Project Collapse Studios
*/

#include "../misc/logger.as"
#include "../misc/assert.as"

#include "../entities/entityarray.as"

[ServerCommand("as_test_entarray", "Testing EntityArray functionality.")]
void TestEntityArray(const CommandArgs@ args)
{
    Logger log("EntityArrayTest_Logger");

    log.Info("Testing EntityArray functionality!");

    log.Info("// ---------- TEST 1: Testing Ideal Functionality");
    log.Info("// ---------- TEST 1-1: Adding entities to an EntityArray by entity name and with a tag.");

    EntityArray entArray;

    // Test adding entities by name with tags
    entArray.AddByEntityName("barney1", EntityTag::NPC, 1);
    entArray.AddByClassname("player", EntityTag::FRIENDLY, 1);
    entArray.AddByClassname("weapon_pistol", EntityTag::CUSTOM, 1);
    entArray.AddByClassname("prop_dynamic", EntityTag::MODEL, 10);
    entArray.PrintArray();

    // Test if entities are correctly added
    //assert(entArray.Length() == 12, "TEST 1-1: Check 1 failed!");
    //assert(entArray.FindByEntityName("relay1").length() == 1, "TEST 1-1: Check 2 failed!");
    //assert(entArray.FindByClassname("npc_barney").length() == 1, "TEST 1-1: Check 3 failed!");
    //assert(entArray.FindByClassname("prop_dynamic").length() == 10, "TEST 1-1: Check 4 failed!");
    //assert(entArray.FindByTag(EntityTag::LOGIC).length() == 1, "TEST 1-1: Check 5 failed!");

    return;

    log.Info("\n");
    log.Info("// ---------- TEST 1-2: Testing equality with another EntityArray.");
    // // Test equality operator
    EntityArray anotherArray;
    anotherArray.AddByEntityName("barney1", EntityTag::NPC, 1);
    anotherArray.AddByClassname("logic_relay", EntityTag::LOGIC, 1);
    anotherArray.AddByClassname("prop_dynamic", EntityTag::MODEL, 10);
    // assert(entArray == anotherArray, "TEST 1-2: Check failed!");

    log.Info("\n");
    log.Info("// ---------- TEST 1-3: Testing removing entities by name.");
    // Test removing entities by name
    entArray.RemoveByEntityName("npc_barney", 1);
    //assert(entArray.Length() == 11, "TEST 1-3: Check 1 failed!");
    //assert(entArray.FindByEntityName("npc_barney").length() == 0, "TEST 1-3: Check 2 failed!");

    // log.Info("\n");
    // log.Info("// ---------- TEST 1-4: Testing sorting entities by tags.");
    // // Test sorting entities by tags
    // entArray.SortEntitiesByTags(true); // Ascending order by tags
    // assert(entArray[0].tags == EntityTag::LOGIC, "TEST 1-4: Check 1 failed!");
    // assert(entArray[1].tags == EntityTag::MODEL, "TEST 1-4: Check 2 failed!");

    // Stress Test

    //log.Info("// ---------- TEST 2-1: Testing stress test scenario adding 1000 entities with random tags.");
    // Add 1000 entities with random tags
    // for (int i = 0; i < 1000; i++)
    // {
    //     EntityTags randomTag = (EntityTags)(1 << (i % 7)); // Cycle through some tags
    //     entArray.AddByEntityName("entity_" + i, randomTag);
    // }
    // assert(entArray.Length() == 1002); // Original 2 entities + 1000 added
    // assert(entArray.FindByTag(EntityTag::LOGIC).length() == 1); // LOGIC should still be there
    // assert(entArray.FindByTag(EntityTag::NONE).length() == 1000); // None should have many added entities

    // // Test removal of entities by class name
    // entArray.RemoveByClassname("prop_dynamic", 1);
    // assert(entArray.FindByClassname("prop_dynamic").length() == 0);

    // // Stress Test - Remove entities and ensure correct removal
    // entArray.RemoveByEntityName("entity_0", 1);
    // assert(entArray.Length() == 1001); // One entity removed
    // assert(entArray.FindByEntityName("entity_0").length() == 0);

    // Error Cases
    // log.Info("\n");
    // log.Info("// ---------- TEST 3: Testing Error Cases");
    // log.Info("// ---------- TEST 3-1: Testing adding an invalid entity handle.");

    // // Test adding an invalid entity handle
    // entArray.AddByHandle(null, EntityTag::NONE); // Should not crash, should be ignored

    // log.Info("\n");
    // log.Info("// ---------- TEST 3-2: Testing removing a non-existing entity.");
    // // Test removing a non-existing entity
    // entArray.RemoveByEntityName("non_existing_entity");
    // assert(entArray.Length() == 1001, "TEST 3-2: Check failed!"); // Should not have changed length

    // log.Info("\n");
    // log.Info("// ---------- TEST 3-3: Testing find a non-existing entity.");
    // // Test finding a non-existing entity
    // array<EntityInfo> nonExistent = entArray.FindByEntityName("non_existing_entity");
    // assert(nonExistent.length() == 0, "TEST 3-3: Check failed!"); // Should return an empty array

    // log.Info("\n");
    // log.Info("// ---------- TEST 3-4: Testing adding entities with conflicting tags.");
    // // Test adding entities with conflicting tags
    // entArray.AddByEntityName("entity_conflict", EntityTag::ENEMY | EntityTag::FRIENDLY);
    // assert(entArray.FindByTag(EntityTag::ENEMY).length() == 1, "TEST 3-4: Check 1 failed!");
    // assert(entArray.FindByTag(EntityTag::FRIENDLY).length() == 1, "TEST 3-4: Check 2 failed!");
    // assert(entArray.FindByTag(EntityTag::ENEMY | EntityTag::FRIENDLY).length() == 1, "TEST 3-4: Check 3 failed!");

    // log.Info("\n");
    // log.Info("// ---------- TEST 4: Testing removing a non-existing entity.");
    // // Remove all entities
    // entArray.Clear();
    // assert(entArray.Length() == 0, "TEST 4: Check failed!"); // After clearing, array should be empty

    log.Info("\n");
    log.Info("EntityArray functionality testing completed!");
    log.Info("----------------------------------------\n");
}
