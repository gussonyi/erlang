1. Introduction.

main.erl: the source code of the testcase module
main.beam: the erlang-formated object file for the testcase module.
generate.beam: the erlang-formated object file for the draw module.
run.bat: the script to run the generate module.

2. Data format sample to be draw Bar Chart

ie.
Data = [ 
                {{"Game1",200},{"Game2",300},{"Game3",100}}, % Monday's Data.
                {{"Game1",297},{"Game2",148},{"Game3",20}}, % Tuesday's Data.
                {{"Game1",123},{"Game2",321},{"Game3",105}}, % Wednesday's Data.
                {{"Game1",450},{"Game2",200},{"Game3",13}}, % Thursday's Data.
                {{"Game1",700},{"Game2",100},{"Game3",90}}, % Friday's Data.
                {{"Game1",34},{"Game2",200},{"Game3",500}}, % Saturday's Data.
                {{"Game1",345},{"Game2",77},{"Game3",400}}  % Sunday's Data.
        ]
for more detail please refer to the file "main.erl".

3. Execute sequence.
 run.bat -> main.beam -> generate.beam

4. Run the program.

Install erlang runtime environment. You should download the installer on windows by: http://www.erlang.org/download.html. After installed the erlang runtime and before you run the progarm,remember add the erl.exe's path to the system environment variable PATH. 

instruction about PATH environ variable:

Open control panel -> system property -> Advance -> environment variable , in the "System variable" section, double click the "Path" Variable.If you install erlang environment in C:\Program Files\erl5.8.4\bin,then add ";C:\Program Files\erl5.8.4\bin" in the end of the variable value(no include the quota)

Then double click the file run.bat. After the run.bat executed,it will generate two pictures in the same directory

5. function documentation of generate module. 

generate:setMaxScaleLimit(Number) -> ok.
	Set The max scale limit of the bar chart.Always return ok.

generate:draw(Data,FileName) -> ok.
	Type:
		Data = [ Tuple1, Tuple2, ... ]
		Tuple1 = {Elem1,Elem2,...}
		Elem1 = {Str1,int()}
		Elem2 = {Str2,int()}
		...
		
		Tuple2 = { Elem3,Elem4,... }
		Elem3 = {Str1,int()}		
		Elem4 = {Str2,int()}		
		...
		
		Str1 = string()
		Str2 = string()

		FileName = string()
	Draw the bar chart named "FileName" according the Data specified.
	