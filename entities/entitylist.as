/**
* @brief   EntityList is custom array type that stores specificly added sets of Entities and information about them.
* @details
* @authors Orsell
*
* @license Distributed under the MIT license - Copyright (c) 2025 Project Collapse Studios
*/

// Tags that can be appended to various EntityInfo's in the
// EntityArray array type to find certain specific entities in the array.
//? Maybe we could have a way to implement custom tags that can be made and applied in special cases.
enum EntityTag
{
    NONE           = 0,      // Entity has no tags.
    LOGIC          = 1 << 0, // Ex. logic_relay
    MODEL          = 1 << 1, // Ex. prop_dynamic
    PUZZLE_ELEMENT = 1 << 2, // Ex. prop_weighted_cube
    NPC            = 1 << 3, // Ex. npc_barney
    FRIENDLY       = 1 << 4, // Ex. Rebels
    ENEMY          = 1 << 5, // Ex. Combine
    CUSTOM         = 1 << 6, // A custom AngelScript entity.

    LAST_TAG       = 1 << 7  // To indicate how many tags exist.
}
typedef uint16 EntityTags; // Max allowed amount of tags currently is 1 << 15, this can easily be changed later.

// Struct to contain the information about an entity in the EntityArray.
class EntityInfo
{
    CBaseEntity@ entHandle;
    EntityTags tags;

    EntityInfo()
    {
        @entHandle = null;
        tags = EntityTag::NONE;
    }

    EntityInfo( CBaseEntity@ handle, EntityTags tags = EntityTag::NONE )
    {
        @entHandle = handle;
        tags = tags;
    }
}

// Custom array type that stores specificly added sets of Entities and information about them.
class EntityArray
{
    array<EntityInfo> entArr;

    /**
    * @brief Clear the contents of the EntityArray.
    */
    void Clear()
    {
        entArr.removeRange(0, entArr.length() - 1);
    }

    /**
    * @brief Add a entity to the EntityArray by its entity name.
    * @param entName Entity name of the entity to add.
    * @param tags (optional) What tags should be added with the entity.
    * @TODO Maybe a "addAmt" like the "rmAmt" that "RemoveByEntityName" does could help.
    */
    void AddByEntityName( const string&in entName, const EntityTags tags = EntityTag::NONE )
    {
        for (CBaseEntity@ ent = null; ent = EntityList().FindByName(ent, entName);)
        {
            entArr.insertLast(EntityInfo(ent, tags));
            DevMsgl("Added entity \"" + ent.GetEntityName() + "\" with entindex \"" + ent.GetEntityIndex() + "\".");
            if (tags > 0)
                DevMsgl("Entity tag value is: \"" + tags + "\"");
        }
    }

    /**
    * @brief Add a entity to the EntityArray by its class name.
    * @param className Class name of the entity to add.
    * @param tags (optional) What tags should be added with the entity.
    * @TODO Maybe a "addAmt" like the "rmAmt" that "RemoveByEntityName" does could help.
    */
    void AddByClassname( const string&in className, const EntityTags tags = EntityTag::NONE )
    {
        for (CBaseEntity@ ent = null; ent = EntityList().FindByClassname(ent, className);)
        {
            entArr.insertLast(EntityInfo(ent, tags));
            DevMsgl("Added entity \"" + ent.GetEntityName() + "\" with entindex \"" + ent.GetEntityIndex() + "\"");
            if (tags > 0)
                DevMsgl("Entity tag value is: \"" + tags + "\"");
        }
    }

    /**
    * @brief Add a entity to the EntityArray by its handle.
    * @param entHandle Handle of the entity to add.
    * @param tags (optional) What tags should be added with the entity.
    * @TODO Maybe a "addAmt" like the "rmAmt" that "RemoveByEntityName" does could help.
    */
    void AddByHandle( const CBaseEntity@ entHandle, const EntityTags tags = EntityTag::NONE )
    {
        if (entHandle == null)
        {
            Warningl("Invalid handle passed to AddByHandle!");
            return;
        }

        entArr.insertLast(EntityInfo(entHandle, tags));
        DevMsgl("Added entity \"" + entHandle.GetEntityName() + "\" with entindex \"" + entHandle.GetEntityIndex() + "\"");
        if (tags > 0)
            DevMsgl("Entity tag value is: \"" + tags + "\"");
    }

    /**
    * @brief Remove entities from the EntityArray by a entity's name.
    * @param entName Name of entity to remove from the array.
    * @param rmAmt (optional) How many of the entity by it's name should be removed.
    */
    void RemoveByEntityName( const string&in entName, int rmAmt = 1 )
    {
        // TODO-FIXME: I believe there is better way to do this, this will work for now.
        for (int i = 0; i < entArr.length(); i++)
        {
            EntityInfo entInfo = entArr[i];
            if ((entInfo.entRef != null) && (entInfo.entRef.GetEntityName() == entName))
            {
                entArr.removeAt(i);
                rmAmt--;
                if (rmAmt <= 0)
                    return;
            }
        }
    }
}
