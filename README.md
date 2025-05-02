# CSV translator system for RPG Maker VXace
<h2>Main thinks</h2>
This script plug'n use able your game to be multilingual with using of csv file. A good comprehension of programmation and csv system are required.<br/>

<h2>How to use:</h2>
-You need to have a <b>CSV</b> named folder in the project root.<br/>
-A CSV folder are offered on the GitHub page, it's containing csv files for Vocab module, actors, armors, class, enemies, items, skills, states and weapons. The csv files offered on the Github page contain translation in English and French.<br/>
-For messages event comand and choice, use this format for display a message contained in a csv file: <b>(tableName, keyName)</b><br/>
-For mark breakline in the csv file, use the new <b>\L</b> message command.<br/>
-All informations to know are writted in the script

<h2>Revisions</h2>
<h3>-v0.7</h3>
-Finish translation of Vocab module.<br/>
-Add translation system for skill types, enemies and states<br/>
<h3>-v0.6</h3>
-Add translation system for skills, same technique as item, weapons and armor.<br/>
-Add <b></b>\L</b> balise for fixing breakline bug for message and descriptions of objects in the database.<br/>
<h3>-v0.5</h3>
-Add translation system for items, weapons and armors in the database, details in the script.<br/>
<h3>-v0.4</h3>
-Folders "Graphics/Pictures", "Graphics/Title1", "Graphics/Title2" and "Movie" can be cahnged depending of language of the game.<br/>
<h3>-v0.3</h3>
-Add method for translate events messages.<br/>
-Add method for translate events choices list.<br/>
-Remove obligation to set MultilingualSystem.first_initialize in Main. Overriding of SceneManager.run.<br/>
<h3>-v0.2</h3>
-Finish implementation of Vocab module in the MultilingueSystem.<br/>
-Add methods for setting language of the game with Game.ini.
<h3>-v0.1:</h3>
-Add partial translation for Vocab module and integrate simple CSV reader.


<h2>TERMS OF USE:</h2>
-Credit ★Yamashi Fenikkusu.<br/>
-You need a valid RPG Maker VXace licence.<br/>
-Free for non commercial and commercial use.<br/>
-You can modify the script for your own usage, but don't redistribute it.<br/>
-Redistribution on other websites without authorization are forbidden.<br/>
-It's not obligatory, but a DM is appreciated if you use this script.
