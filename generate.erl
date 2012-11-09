-module(generate).
-import(egd).
-import(egd_font).
-compile(export_all).
-export([draw/2,setMaxScaleLimit/1]).

setMaxScaleLimit(Num) ->
	IntNum = case erlang:is_integer(Num) of
		true -> Num;
		false -> io:format("Max scale number is illegal,set the max scale number to default.~n"), 1000
	end,
	FinNum = if
		IntNum =< 300 -> 300;
		true -> IntNum
	end,
	put("MaxScaleLimit",FinNum),
	ok.

getMaxScaleLimit() ->
	Max = get("MaxScaleLimit"),
	case Max of
		undefined -> 1000;
		_ -> Max
	end.

margin() -> 50.
verticalAddMargin() -> 50.
horizonAddMargin() -> 25.
columnWidth() -> 40.
columnNum() -> 7.
intervalWidth() -> 40.
intervalNum() -> 8.
tableHeight() -> 300.
blankpix() -> 1+1.
%yMaxUnit() -> 1000.
yPieces() -> 10.
colors() -> [{155,187,88},{192,80,78},{79,129,188},{86,140,89},{123,56,78}].

tableWidth() -> columnWidth()*columnNum() + intervalWidth()*intervalNum().
horizonMargin() -> margin()+horizonAddMargin().
verticalMargin() -> margin()+verticalAddMargin().

xLineCoordinate() -> {{verticalMargin()+blankpix(),margin()+tableHeight()},
	{verticalMargin()+blankpix()+tableWidth(),margin()+tableHeight()}}.
yLineCoordinate() -> {{verticalMargin()+blankpix(),margin()},
	{verticalMargin()+blankpix(),margin()+tableHeight()}}.

picWidth() -> verticalMargin() + blankpix() - 1 + tableWidth() + 2*margin().
picHeight() -> horizonMargin() + blankpix() - 1 + tableHeight() + margin().

drawBar(Elem) ->
	Black = egd:color({0,0,0}),
	Filename = filename:join([code:priv_dir(percept), "fonts", "6x11_latin1.wingsfont"]),
	Font = egd_font:load(Filename),
	{Img,{TextPoint,String},{StartPoint,EndPoint}} = Elem,
	egd:line(Img,StartPoint,EndPoint,Black),
	egd:text(Img, TextPoint , Font, String, Black).
	
drawYPieceLine(Img,Pieces,YMaxUnit) ->
	Res1 = case (catch(YMaxUnit/Pieces)) of
		{'EXIT',_} -> io:format("Divide by 0~n"),exit(0);
		Val2 -> erlang:trunc(Val2)
	end,
	Step1 = case Res1 of
		0 -> io:format("Pieces Unit can not be 0!~n"),exit(0);
		Re1 -> Re1
	end,
	Res2 = case (catch(tableHeight()/Pieces)) of
		{'EXIT',_} -> exit(0);
		Val3 -> erlang:trunc(Val3)
	end,
	Step2 = case Res2 of
		0 -> io:format("Pieces Pixel can not be 0!~n"),exit(0);
		Re2 -> Re2
	end,
	{{_,StartY},{_,_}} = yLineCoordinate(),
	{{X1,FinishY},{X2,_}} = xLineCoordinate(),
	Li = lists:seq(StartY,FinishY,Step2),
	TempScale = lists:seq(0,YMaxUnit,Step1),
	ScaleYList = Li,
	ScaleXList = lists:duplicate(Pieces+1,margin()),
	ScaleXYList = lists:zip(ScaleXList,ScaleYList),
	Str = lists:map(fun erlang:integer_to_list/1 , lists:reverse(TempScale) ),
	Scale = lists:zip(ScaleXYList,Str),
	Lines = [ {{X1,Y},{X2,Y}}  || Y <- Li ],
	Imgs = lists:duplicate(erlang:length(Scale),Img),
	LinesAndYUnit = lists:zip3(Imgs,Scale,Lines),
	lists:foreach(fun drawBar/1,LinesAndYUnit),
	ok.

drawYAxes(Img,YPieces,YMaxUnit) ->
	Black = egd:color({0,0,0}),
	{Xstart,Xend} = xLineCoordinate(),
	egd:line(Img, Xstart, Xend, Black),
	{Ystart,Yend} = yLineCoordinate(),
	egd:line(Img, Ystart, Yend, Black),
	drawYPieceLine(Img,YPieces,YMaxUnit),
	ok.

createBlankPicture() ->
	White = egd:color({255,255,255}),
	Img = egd:create(picWidth(),picHeight()),
	egd:filledRectangle(Img, {0,0}, {picWidth()-1,picHeight()-1}, White),
	Img.


drawWeek(Elem) ->
	Black = egd:color({0,0,0}),
	Filename = filename:join([code:priv_dir(percept), "fonts", "6x11_latin1.wingsfont"]),
	Font = egd_font:load(Filename),
	{Img,String,Point} = Elem,
	egd:text(Img,Point, Font, String, Black).

drawWeeks(Img,WeekPoints) ->
	AWeek = ["Mon","Tues","Wed","Thurs","Fri","Sat","Sun"],
	Imgs = lists:duplicate(columnNum(),Img),
	TextAxesList = lists:zip3(Imgs,AWeek,WeekPoints),
	lists:foreach(fun drawWeek/1,TextAxesList).

allsame(Li) ->
	[First|_] = Li,
	lists:all(fun(X)-> X =:= First end,Li).

countTuple(Tup) ->
	Li = erlang:tuple_to_list(Tup),
	erlang:length(Li).

extractFirst(Tup) ->
	Li = erlang:tuple_to_list(Tup),
	{A,_} = lists:unzip(Li),
	A.

extractSecond(Tup) ->
	Li = erlang:tuple_to_list(Tup),
	{_,B} = lists:unzip(Li),
	B.

checkData(Data) ->
	DaysNum = erlang:length(Data),
	case DaysNum of
		7 -> 7;
		_ -> io:format("Data is ilegal: Data must be a week~n"),exit(1)
	end,
	Nums = lists:map(fun countTuple/1, Data),
	Num = case allsame(Nums) of
		true -> [N|_] = Nums,N;
		_ -> io:format("Data is ilegal: Data item number must be same~n"),exit(1)
	end,
	GamesList = lists:map(fun extractFirst/1,Data),
	Games = case allsame(GamesList) of
		true -> [Gam|_] = GamesList,Gam;
		_ -> io:format("Data is ilegal: Game name not consistent~n"),exit(0)
	end,
	NumGames = erlang:length(Games),
	NumColors = erlang:length(colors()),
	Err = if
		NumGames > NumColors -> 1;
		true -> 0
	end,
	case Err of
		1 -> io:format("Data iterm more than the number of color.~n"),exit(0);
		_ -> ok
	end,
	Games.

conNumber2Pixel(Num) ->
	-erlang:trunc(tableHeight() * Num / getMaxScaleLimit()).

convertNumber(Li) -> % [100,200,300]
	lists:map(fun conNumber2Pixel/1 , Li).

takeNColors(Tup) ->
	{Seq,Max,_} = Tup,
	if
		Seq =< Max -> true;
		true -> false
	end.

takeThirdEl(Tup) ->
	{_,_,A} = Tup,
	A.
	
takeNColors(Li,N) ->
	Number = erlang:length(Li),
	Seq = lists:seq(1,Number),
	Max = lists:duplicate(Number,N),
	NewL = lists:zip3(Seq,Max,Li),
	AL = lists:filter(fun takeNColors/1,NewL),
	lists:map(fun takeThirdEl/1,AL).

againzip(Li) ->
	{La,Lb} = Li,
	lists:zip(La,Lb).	

colorPix(Colors,PixelList) ->
	LenPixList = erlang:length(PixelList),
	LenColrList = lists:duplicate(LenPixList,Colors),
	Te = lists:zip(LenColrList,PixelList),
	Tt = lists:map(fun againzip/1,Te).

drawSection(Elem,Acc) -> %% TODO: 
	{X,Y} = Acc,
	{Color,Offset} = Elem,
	Col = egd:color(Color),
	Img = get("ImageAboutDraw"),
	egd:filledRectangle(Img, Acc , {X+columnWidth(),Y+Offset}, Col),
	{ X , Y + Offset }. %% return Acc

drawSections(StartPoint,ColorAndOffset) ->
	lists:foldl(fun drawSection/2,StartPoint,ColorAndOffset).

drawRealColum(Tup) ->
	{StartPoint,ColorAndOffset} = Tup,
	drawSections(StartPoint,ColorAndOffset),
	ok.

drawRealColumns(Li) ->
	lists:map(fun drawRealColum/1,Li).

accColorGame(Elem,Point) ->
	Black = egd:color({0,0,0}),
	Filename = filename:join([code:priv_dir(percept), "fonts", "6x11_latin1.wingsfont"]),
	Font = egd_font:load(Filename),
	{Color,Game} = Elem,
	{X,Y} = Point,
	Col = egd:color(Color),
	Img = get("ImageAboutDraw"),
	egd:filledRectangle(Img,Point,{X+10,Y+10},Col),
	egd:text(Img,{X+12,Y} , Font, Game, Black),
	{X,Y+20}.

drawColorGameList(List) ->
	StartPoint = get("ColorGameStart"),
	lists:foldl(fun accColorGame/2 , StartPoint,List),
	ok.

drawColumns(Img,Data,ColumnPoints) ->
	put("ImageAboutDraw",Img),
	Games = checkData(Data),
	GameNum = erlang:length(Games),
	Colors = takeNColors(colors(),GameNum),
	ColorGameList = lists:zip(Colors,Games),
	ColorGameStart = { verticalMargin() + blankpix() - 1 + tableWidth() + 20 ,
			horizonMargin() + blankpix() - 1 + erlang:trunc(tableHeight()/3) },
	put("ColorGameStart",ColorGameStart),
	drawColorGameList(ColorGameList),
	NumberList = lists:map(fun extractSecond/1,Data),
	PixelList = lists:map(fun convertNumber/1, NumberList),
	ColorPixList = colorPix(Colors,PixelList),
	AxesColorPixList = lists:zip(ColumnPoints,ColorPixList),
	io:format("AxesColorPixList = ~p~n",[AxesColorPixList]),
	drawRealColumns(AxesColorPixList).

drawXAxes(Img,Data) ->
	{{StartX,StartY},_} = xLineCoordinate(),
	ListX = lists:seq(StartX+columnWidth(),tableWidth()+columnWidth()+intervalWidth(),columnWidth()+intervalWidth()),
	ListYColumn = lists:duplicate(columnNum(),margin()+tableHeight()),
	ListYWeek = lists:duplicate(columnNum(),margin()+tableHeight()+3),
	WeekPoints = lists:zip(ListX,ListYWeek),
	ColumnPoints = lists:zip(ListX,ListYColumn),
	drawWeeks(Img,WeekPoints),
	drawColumns(Img,Data,ColumnPoints),
	ok.

draw(Data,FileName) ->
	Img = createBlankPicture(),
	drawYAxes(Img,yPieces(),getMaxScaleLimit()),
	drawXAxes(Img,Data),
	egd:save(egd:render(Img, png),FileName),
	egd:destroy(Img),
	ok.
