# RMVXace multilingual system - Translation tool
<h2>Main thinks</h2>
This script plug'n use able your game to be multilingual with using of csv file. A good comprehension of programmation and csv system are required.<br/>

<h2>How to use:</h2>
-You need to have a <sub>CSV</sub> named folder in the project root.<br/>
-You have to put MultilingualSystem.init_language at the end of Main script.<br/>
-A CSV folder are offered on the GitHub page, it's containing a csv file for Vocab module. Files csv for actors, weapons will come later. The csv files offered on the Github page contain translation in English and French.<br/>
-For messages event comand and choice, use this format for display a message contained in a csv file: <sub>(tableName, keyName)</sub>

<h2>Revisions</h2>
<h3>-v0.3</h3>
-Add method for translate events messages.<br/>
-Add method for translate events choices list.<br/>
<h3>-v0.2</h3>
-Finish implementation of Vocab module in the MultilingueSystem.<br/>
-Add methods for setting language of the game with Game.ini.
<h3>-v0.1:</h3>
-Add partial translation for Vocab module and integrate simple CSV reader.
