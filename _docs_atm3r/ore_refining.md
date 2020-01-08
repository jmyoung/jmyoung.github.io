---
layout: page
title: Ore Refining with Mekanism
---

Mekanism provides ways that you can get up to 5x the ingots from a single unit of ore, but this requires quite a bit of infrastructure to be set up.  This info has been mostly lifted from the [Ore Processing](https://wiki.aidancbrady.com/wiki/Ore_Processing) guide, but with some adjustments to suit ATM3R and what's available in this pack.

Use XNet to route all the materials, since XNet can natively handle Mekanism gases, fluids, and items all in one set of cabling.

# Tier 0 (1x)

Basic smelting.  In this we use a Redstone Furnace from TE, because it's pretty fast and easy to make.  Any furnace will do.

{% raw %}
<div class="mermaid">
  graph TD;
  RawOre[1 Raw Ore] --> Or((OR));
  Dust[Dust] --> Or((OR));
  Or --> RedstoneFurnace{{Redstone Furnace}};
  RedstoneFurnace --> Ingot[1 Ingot];
</div>
{% endraw %}

# Tier 1 (2x)

Ore Doubling.  Outputs Dust, which you then send into the Tier 0 system.

{% raw %}
<div class="mermaid">
  graph TD;
  RawOre[1 Raw Ore] --> Or((OR));
  DirtyDust[Dirty Dust] --> Or((OR));
  Or --> EnrichmentChamber{{EnrichmentChamber}};
  EnrichmentChamber --> Dust[Dust];
</div>
{% endraw %}

# Tier 2 (3x)

Ore Tripling.  Outputs Dirty Dust, which goes into the Tier 1 system.

{% raw %}
<div class="mermaid">
  graph TD;
  RawOre[1 Raw Ore] --> Or((OR));
  Shard[Shard] --> Or((OR));
  Or --> PurificationChamber{{Purification Chamber}};
  Oxygen --> PurificationChamber;
  PurificationChamber --> Clump[3 Clumps];
  Clump --> Crusher{{Crusher}};
  Crusher --> DirtyDust[Dirty Dust];
</div>
{% endraw %}

Tripling also requires Oxygen, which you can derive with;

## Hydrogen and Oxygen

{% raw %}
<div class="mermaid">
  graph TD;
  Sink{{Sink}} --> Water[Water];
  Water --> ElectroSeparator{{Electrolytic Separator}};
  ElectroSeparator --> Hydrogen[Hydrogen];
  ElectroSeparator --> Oxygen[Oxygen];
  Hydrogen --> GasBurningGen{{Gas-Burning Generator}};
</div>
{% endraw %}

# Tier 3 (4x)

Ore Quadrupling.  Outputs Shards, which go into the Tier 2 system.

{% raw %}
<div class="mermaid">
  graph TD;
  RawOre[1 Raw Ore] --> Or((OR));
  Crystal[Crystal] --> Or((OR));
  Or --> ChemInjChamber{{Chemical Injection Chamber}};
  HCL[Hydrogen Chloride] --> ChemInjChamber;
  ChemInjChamber --> Shard[Shards];
</div>
{% endraw %}

This process will require Hydrogen Chloride which you can derive a few different ways, this is likely the most repeatable way;

## Chlorine

{% raw %}
<div class="mermaid">
  graph TD;
  Sink{{Sink}} --> Water[Water];
  Water --> SolarEvap{{Solar Evaporation Plant}};
  SolarEvap --> Brine[Brine];
  Brine --> ElectroSeparator{{Electrolytic Separator}};
  ElectroSeparator --> Sodium[Sodium];
  ElectroSeparator --> Chlorine[Chlorine];
</div>
{% endraw %}

## Hydrogen Chloride

You'll need the Hydrogen from the Tier 2 process to make into Hydrogen Chloride;

{% raw %}
<div class="mermaid">
  graph TD;
  Hydrogen[Hydrogen] --> ChemInfuser{{Chemical Infuser}};
  Chlorine[Chlorine] --> ChemInfuser;
  ChemInfuser --> HCL[Hydrogen Chloride];  
</div>
{% endraw %}

# Tier 4 (5x)

Here's where it all happens.  Ore quintupling.  The ultimate.  Produces Crystals which go into Tier 3.

You'll need Water from previous tiers here as well as Sulfuric Acid.

{% raw %}
<div class="mermaid">
  graph TD;
  RawOre[1 Raw Ore] --> ChemDissChamber{{Chemical Dissolution Chamber}};
  SulfuricAcid[Sulfuric Acid] --> ChemDissChamber;
  ChemDissChamber --> OreSlurry[Ore Slurry];
  OreSlurry --> ChemWasher{{Chemical Washer}};
  Water --> ChemWasher;
  ChemWasher --> CleanSlurry[Clean Ore Slurry];
  CleanSlurry --> ChemCrystallizer{{Chemical Crystallizer}};
  ChemCrystallizer --> Crystal[Crystals];
</div>
{% endraw %}

## Sulfur

Sulfuric Acid is fairly extensive, but there's a few ways you can make it effectively.  First we'll cover Sulfur.

Sulfur is available as a loot drop from Woot farms for various mobs.  This should probably be your first port of call for Sulfur, alternatively you can derive it from Gravel and Hydrogen Chloride;

{% raw %}
<div class="mermaid">
  graph TD;
  Stoneworks{{Material Stonework Factory}} --> Gravel[Gravel];
  Gravel --> Crafter{{Crafter Tier 1}};
  Crafter --> Flint[Flint];
  Flint --> Pulverizer{{Pulverizer}};
  Pulverizer --> Gunpowder[Gunpowder];
  Gunpowder --> ChemInjChamber{{Chemical Injection Chamber}};
  HCL[Hydrogen Chloride] --> ChemInjChamber;
  ChemInjChamber --> Sulfur[Sulfur];
</div>
{% endraw %}

## Sulfur Trioxide

The next step is to generate a supply of Sulfur Trioxide;

{% raw %}
<div class="mermaid">
  graph TD;
  Sulfur[Sulfur] --> ChemOxidizer{{Chemical Oxidizer}};
  ChemOxidizer --> SulfurDioxide[Sulfur Dioxide];
  SulfurDioxide --> ChemInfuser{{Chemical Infuser}};
  Oxygen --> ChemInfuser;
  ChemInfuser --> SulfurTrioxide[Sulfur Trioxide];
</div>
{% endraw %}

## Sulfuric Acid

And finally we produce Sulfuric Acid.

{% raw %}
<div class="mermaid">
  graph TD;
  SulfurTrioxide[Sulfur Trioxide] --> ChemInfuser{{Chemical Infuser}};
  WaterVapor[Water Vapor] --> ChemInfuser;
  ChemInfuser --> SulfuricAcid[Sulfuric Acid];
  Water[Water] --> RotaryConden{{Rotary Condensentrator}};
  RotaryConden --> WaterVapor;
</div>
{% endraw %}