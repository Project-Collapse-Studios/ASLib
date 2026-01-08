/**
* @brief   EntityList is custom array type that stores specifically added sets of Entities and information about them.
* @details
* @authors Orsell
*
* @license Distributed under the MIT license - Copyright (c) 2026 Project Collapse Studios
*/

// Tags that can be appended to various EntityInfo's in the EntityArray to find certain specific entities in the array.
//? Maybe we could have a way to implement custom tags that can be made and applied in special cases at runtime?
// TODO: Currently these were just examples of tags we could have, these can be changed out or changed with whatever.
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

// "Struct" to contain the information about an entity in the EntityArray.
final class EntityInfo
{
    CBaseEntity@ entHandle; // Handle for the entity.
    EntityTags tags; // unint16 number that holds bits.

    /**
    * @brief Default constructor.
    */
    EntityInfo()
    {
        @entHandle = null;
        tags = EntityTag::NONE;
    }

    /**
    * @brief Constructor with arguments.
    * @param newEntHandle A CBaseEntity handle to pass to the EntityInfo to store.
    * @param tags What tags should be associated with the entity.
    */
    EntityInfo( CBaseEntity@ newEntHandle, EntityTags tags = EntityTag::NONE )
    {
        @entHandle = newEntHandle;
        tags = tags;
    }

    /**
    * @brief Assign the contents of one EntityInfo's to another.
    * @param rhs EntityInfo on the right hand side.
    */
    EntityInfo& opAssign( const EntityInfo& rhs )
    {
        this.entHandle = rhs.entHandle;
        this.tags = rhs.tags;
    }

    /**
    * @brief Check if two EntityInfo's are equal.
    * @param rhs EntityInfo on the right hand side.
    */
    bool opEquals( const EntityInfo&in rhs ) const
    {
        if ((this.entHandle != rhs.entHandle) || (this.tags != rhs.tags))
            return false;

        return true;
    }
}

// Custom array type that stores specifically added sets of Entities and information about them.
class EntityArray
{
    // The underlying array that holds all the EntityInfo "structs".
    array<EntityInfo> entArr;

    /**
    * @brief Assign the contents of one EntityArray array to another EntityArray.
    * @param rhs EntityArray on the right hand side.
    */
    EntityArray& opAssign( const EntityArray& rhs )
    {
        this.entArr = rhs.entArr;
    }

    /**
    * @brief Check if two EntityArray's are equal.
    * @param rhs EntityArray on the right hand side.
    * @note Order of EntityInfo's in the array matters, and for each index the inside items match.
    */
    bool opEquals( const EntityArray&in rhs ) const
    {
        // Checking if the length is different.
        if (this.entArr.length() != rhs.entArr.length())
            return false;

        // Checking individual items of the array.
        for (int i = 0; i < this.entArr.length(); i++)
        {
            if (this.entArr[i] != rhs.entArr[i])
                return false;
        }

        return true;
    }

    /**
    * @brief Access a EntityInfo by index from the array.
    */
    EntityInfo& opIndex( uint index ) { return entArr[index]; }
    const EntityInfo& opIndex( uint index ) const { return entArr[index]; }

    /**
    * @brief For statement operator overloads for usage with foreach as indexes.
    */
    uint opForBegin() const { return 0; }
    bool opForEnd( uint index ) const { return index >= entArr.length(); }
    uint opForNext( uint index ) const { return index + 1; }

    /**
    * @brief Clear all the entities from the EntityArray.
    */
    void Clear() { entArr.removeRange(0, entArr.length() - 1); }


    // ---------------- ADDING FUNCTIONS ---------------- \\

    /**
    * @brief Add a entity to the EntityArray by its entity name.
    * @param entName Entity name of the entity to add.
    * @param tags (optional) What tags should be added with the entity.
    * @// TODO Maybe a "addAmt" like the "rmAmt" that "RemoveByEntityName" does could help.
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
    * @// TODO Maybe a "addAmt" like the "rmAmt" that "RemoveByEntityName" does could help.
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
    * @// TODO Maybe a "addAmt" like the "rmAmt" that "RemoveByEntityName" does could help.
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


    // ---------------- REMOVING FUNCTIONS ---------------- \\

    /**
    * @brief Remove entities from the EntityArray by a entity's name.
    * @param entName Name of entity to remove from the array.
    * @param rmAmt (optional) How many of the entity by it's name should be removed.
    */
    void RemoveByEntityName( const string&in entName, int rmAmt = 1 )
    {
        // TODO-FIXME: foreach would work better here, but for some reason the AS extension is saying it's invalid and doesn't exist?
        for (int i = 0; i < entArr.length(); i++)
        {
            EntityInfo entInfo = entArr[i];
            if ((entInfo.entHandle != null) && (entInfo.entHandle.GetEntityName() == entName))
            {
                entArr.removeAt(i);
                DevMsgl("Removed entity \"" + entInfo.entHandle.GetEntityName() + "\" with entindex \"" + entInfo.entHandle.GetEntityIndex() + "\"");
                rmAmt--;
                if (rmAmt <= 0)
                    return;
            }
        }
    }

    /**
    * @brief Remove entities from the EntityArray by a entity's class name.
    * @param className Class name of entity to remove from the array.
    * @param rmAmt (optional) How many of the entity by it's class name should be removed.
    */
    void RemoveByClassname( const string&in className, int rmAmt = 1 )
    {
        // TODO-FIXME: foreach would work better here, but for some reason the AS extension is saying it's invalid and doesn't exist?
        for (int i = 0; i < entArr.length(); i++)
        {
            EntityInfo entInfo = entArr[i];
            if ((entInfo.entHandle != null) && (entInfo.entHandle.GetClassname() == className))
            {
                entArr.removeAt(i);
                DevMsgl("Removed entity \"" + entInfo.entHandle.GetEntityName() + "\" with entindex \"" + entInfo.entHandle.GetEntityIndex() + "\"");
                rmAmt--;
                if (rmAmt <= 0)
                    return;
            }
        }
    }

    /**
    * @brief Remove entity from the EntityArray by a CBaseEntity handle.
    * @param entHandle Handle of the entity to remove from the array.
    */
    void RemoveByHandle( const CBaseEntity@ entHandle )
    {
        // TODO-FIXME: foreach would work better here, but for some reason the AS extension is saying it's invalid and doesn't exist?
        for (int i = 0; i < entArr.length(); i++)
        {
            EntityInfo entInfo = entArr[i];
            if ((entInfo.entHandle != null) && (entInfo.entHandle == entHandle))
            {
                DevMsgl("Removed entity \"" + entInfo.entHandle.GetEntityName() + "\" with entindex \"" + entInfo.entHandle.GetEntityIndex() + "\"");
                entArr.removeAt(i);
                return;
            }
        }
    }


    // ---------------- SORTING FUNCTIONS ---------------- \\

    /**
    * @brief Compare tags of entities for sorting ascendingly.
    * @param A Entity A.
    * @param B Entity B.
    */
    bool SortByTagsAsc( const EntityInfo@ A, const EntityInfo@ B )
    {
        if (A.tags < B.tags)
            return true;

        return false;
    }

    /**
    * @brief Compare tags of entities for sorting descendingly.
    * @param A Entity A.
    * @param B Entity B.
    */
    bool SortByTagsDesc( const EntityInfo@ A, const EntityInfo@ B )
    {
        if (A.tags < B.tags)
            return false;

        return true;
    }

    /**
    * @brief Sort entities in the EntityArray by their tag value.
    * @param ascending Whether to sort ascendingly or decendingly.
    */
    void SortEntitiesByTags( bool ascending = true )
    {
        // TODO: Forgot this was a issue, normal sort function is incomplete by the dump so this is my assumption take on what "T[]::less" actually is.
        // TODO: Guess we have to wait till the dump is fixed or think of something else.
        if (ascending)
            entArr.sort(SortByTagsAsc);
        else
            entArr.sort(SortByTagsDesc);
    }


    // ---------------- FIND FUNCTIONS ---------------- \\
    // TODO: Should try and take advantage of using the array's find functions for CBaseEntity handles,
    // TODO: however the issue is that the array type used is EntityInfo so CBaseEntity can't be used.

    /**
    * @brief Find entities in the EntityArray by a CBaseEntity handle.
    * @param handle Handle to search for in the array.
    * @return Simple array of EntityInfo with the given handle.
    */
    array<EntityInfo> FindByHandle( const CBaseEntity@ handle )
    {
        array<EntityInfo> results;
        for (int i = 0; i < entArr.length(); i++)
        {
            if (entArr[i].entHandle == handle)
                results.insertLast(entArr[i]);
        }

        return results;
    }

    /**
    * @brief Find entities in the EntityArray by an entity name.
    * @param entName Name of entity to search for in the array.
    * @return Simple array of EntityInfo with the given name.
    */
    array<EntityInfo> FindByName( const string&in entName )
    {
        array<EntityInfo> results;
        for (int i = 0; i < entArr.length(); i++)
        {
            if (entArr[i].entHandle.GetEntityName() == entName)
                results.insertLast(entArr[i]);
        }

        return results;
    }

    /**
    * @brief Find entities in the EntityArray by a class name.
    * @param className Class name of entity to search for in the array.
    * @return Simple array of EntityInfo with the given class name.
    */
    array<EntityInfo> FindByClassname( const string&in className )
    {
        array<EntityInfo> results;
        for (int i = 0; i < entArr.length(); i++)
        {
            if (entArr[i].entHandle.GetClassname() == className)
                results.insertLast(entArr[i]);
        }

        return results;
    }

    /**
    * @brief Find entities in the EntityArray by EntityTags.
    * @param tag Tags to search for in the array.
    * @return Array of entities with the given tags.
    */
    array<EntityInfo> FindByTag( const EntityTags tag )
    {
        array<EntityInfo> results;
        for (int i = 0; i < entArr.length(); i++)
        {
            if (entArr[i].tags & tag)
            {
                results.insertLast(entArr[i]);
            }
        }

        return results;
    }
}
