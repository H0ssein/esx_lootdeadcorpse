# esx_irforce_lootdeadcorpse

this is my very first script

it allows specific jobs to loot dead corpse, of course with a cute animation by pressing 'E'.


### Prerequisites

only works with ESX
## Demo
[![Watch the video](https://cdn.discordapp.com/attachments/584460034541617172/631138375189004288/unknown.png)](https://cdn.discordapp.com/attachments/587184003291938817/631087554665381898/IRforCe_Loot_The_Dead_Corpse.mp4)

## Installing

after download/clone rename the folder from 
```
irforce_lootdeadcorpsee-master
```
to
```
irforce_lootdeadcorpse
```
then goto to the address below and change the jobs name of your liking
```
irforce_lootdeadcorpse/client/main.lua:29
```
just replace the "jobname-here" with the job name you like
for example:
```
if IsControlJustReleased(0, 38) and ( ESX.PlayerData["job"]["name"] == "fbi" or ESX.PlayerData["job"]["name"] == "police" ) then
```
or if you like to allow all players to loot, just remove the code below
```
and ( ESX.PlayerData["job"]["name"] == "jobname-here" or ESX.PlayerData["job"]["name"] == "jobname-here" )
```
and it will looks like this:
```
if IsControlJustReleased(0, 38) then
```
also you can change config file to your liking

and for the final step put the line below in your server.cfg file
```
start irforce_lootdeadcorpse
```
## Donate

Donations are never necessary, but it is highly appreciated. I put in average 8 Hours a day to develop or optimize the scripts. Please consider donation if you enjoyed my work and as always please only donate if the money is yours and it will not hurt you in anyway. Thanks a lot ❤️

[![Donate](https://cdn.discordapp.com/attachments/584460034541617172/631246271277039616/donate-paypal-main.png)](https://paypal.me/donatescript)

### forum link
[[Release] [ESX] IRforCe Loot The Dead Corpse](https://forum.fivem.net/t/release-esx-irforce-loot-the-dead-corpse/826653)
## Enjoy it🤩

## Credits

Please read [Credits.md](https://github.com/H0ssein/irforce_lootdeadcorpse/blob/master/Credits.md) for more information.
