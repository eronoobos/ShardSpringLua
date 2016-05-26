# ShardSpringLua

## [Shard](https://github.com/Tarendai/Shard) as a [Spring](https://github.com/spring/spring) [Lua AI](https://springrts.com/wiki/AI:Development:Lang:Lua)

### Basic Information

This is a Spring mod archive that Spring games may put in their dependencies. This is only the Lua AI base. To run the AI, games must also include a Shard configuration.

### How To

Clone this repository into a Spring archive in its games directory.
```
git clone https://github.com/eronoobos/ShardSpringLua.git ~/.spring/games/ShardSpringLua.sdd
```

Add this mod as a dependency to your game's modinfo.lua. For example:
```
return {
  name='Balanced Annihilation',
  description='Balanced Annihilation',
  shortname='BA',
  version='shard',
  mutator='Official',
  game='Total Annihilation',
  shortGame='TA',
  modtype=1,
  depend = {
    "Shard LuaAI $VERSION",
    "Balanced Annihilation Shard LuaAI $VERSION",        
  },
}
```

The second dependency line, `"Balanced Annihilation Shard LuaAI $VERSION"`, is the game's Shard configuration archived in a Spring mod. See [Balanced-Annihilation-Shard-LuaAI](https://github.com/eronoobos/Balanced-Annihilation-Shard-LuaAI) for an example.