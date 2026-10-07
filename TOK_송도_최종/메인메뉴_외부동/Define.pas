unit Define;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, StdCtrls, ComCtrls;

const
  Backspace = #8;
  Del       = #46;
  Enter     = #13;
  Tab       = #9;

// 개별 Rack 의 측면 그림을 위한 변수
  Start_Loc_x: Integer = 10;
  Start_Loc_y: Integer = 80;

  size_bay_x: Integer = 45;
  size_bay_y: Integer = 25;


// 주화면에 자동창고 평면 그림을 위한 변수
  start_x: integer = 80;                     // 그림의 시작위치 (수평 - 맨 왼쪽)
  start_y: integer = 0;                     // 그림의 시작위치 (수직 - 맨 상단)

  // 자동 창고 평면 그림에 사용되어지는 변수
  start_rack_x: integer = 250;        // Rack의 시작 위치 (수평)
  start_rack_y: integer = 200;        // Rack의 시작 위치 (수직)

  size_rack_x:  integer  = 45;        // Rack 한 Cell의 크가 (수평)
  size_rack_y:  integer  = 25;        // Rack 한 Cell의 크가 (수직)


  size_crane_x:  integer = 45;        // Crane의 크기 (수평)
  size_crane_y:  integer = 25;        // Crane의 크기 (수직)


  size_space_bay :  integer = 1;
  size_space_bank:  integer = 1;
  size_space_rack:  integer = 1;

  RailOffset:  Integer = 2;

  ToggleFlag: Integer = 0;

  addmax: array [1..4] of Integer = (511, 1151, 3071, 3071);

var
// 자동창고 주변수 ( SC, RACK의 크기)
  MaxSc:   Integer = 3;
  MaxBay:  Integer = 13;
  MaxLevl: Integer = 3;

  RailTop, RailLeft, RailWidth, RailHeight : Integer;
  Pos_y, Pos_x : Integer;

implementation

end.
