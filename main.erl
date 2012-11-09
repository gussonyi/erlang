-module(main).
-import(generate).
-compile(export_all).

main() ->
	io:format("Begin draw picture...~n"),

	% Begin first picture, 3 kinds of Game data.
	Data1 = [
		{{"Game1",200},{"Game2",300},{"Game3",100}}, % Monday's Data.
		{{"Game1",297},{"Game2",148},{"Game3",20}}, % Tuesday's Data.
		{{"Game1",123},{"Game2",321},{"Game3",105}}, % Wednesday's Data.
		{{"Game1",450},{"Game2",200},{"Game3",13}}, % Thursday's Data.
		{{"Game1",700},{"Game2",100},{"Game3",90}}, % Friday's Data.
		{{"Game1",34},{"Game2",200},{"Game3",500}}, % Saturday's Data.
		{{"Game1",345},{"Game2",77},{"Game3",400}}  % Sunday's Data.
	],
	Name1 = "BarChart1.png",
	generate:draw(Data1,Name1),

	% Begin draw second picture, 4 kinds of Game data
	Data2 = [
		{{"Game1",200},{"Game2",300},{"Game3",100},{"Game4",20}}, % Monday's Data.
		{{"Game1",297},{"Game2",148},{"Game3",20},{"Game4",23}}, % Tuesday's Data.
		{{"Game1",123},{"Game2",321},{"Game3",105},{"Game4",100}}, % Wednesday's Data.
		{{"Game1",450},{"Game2",200},{"Game3",13},{"Game4",200}}, % Thursday's Data.
		{{"Game1",200},{"Game2",100},{"Game3",90},{"Game4",140}}, % Friday's Data.
		{{"Game1",34},{"Game2",200},{"Game3",500},{"Game4",200}}, % Saturday's Data.
		{{"Game1",345},{"Game2",77},{"Game3",400},{"Game4",90}}  % Sunday's Data.
	],
	Name2 = "BarChart2.png",
	generate:draw(Data2,Name2),

	% Begin draw third picture, set new max scale limit.
	Data3 = [
		{{"Game1",200},{"Game2",300},{"Game3",100},{"Game4",20}}, % Monday's Data.
		{{"Game1",297},{"Game2",148},{"Game3",20},{"Game4",23}}, % Tuesday's Data.
		{{"Game1",123},{"Game2",321},{"Game3",105},{"Game4",100}}, % Wednesday's Data.
		{{"Game1",450},{"Game2",200},{"Game3",13},{"Game4",200}}, % Thursday's Data.
		{{"Game1",200},{"Game2",100},{"Game3",90},{"Game4",140}}, % Friday's Data.
		{{"Game1",34},{"Game2",200},{"Game3",500},{"Game4",200}}, % Saturday's Data.
		{{"Game1",345},{"Game2",77},{"Game3",400},{"Game4",90}}  % Sunday's Data.
	],
	Name3 = "BarChart3.png",
	generate:setMaxScaleLimit(2000),
	generate:draw(Data3,Name3).

