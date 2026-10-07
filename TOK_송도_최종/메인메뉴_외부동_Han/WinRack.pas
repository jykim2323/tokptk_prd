unit WinRack;

interface

  private

    procedure Dwaw;

implementation

procedure Draw;
Begin
   With FrmMain.Canvas do
   Begin
      // 스테커 크레인 주행 레일을 그린다.
      // 시작 위치 Rack그림의 맨 좌측 상단 부터 시작 한다.
      // 주행 레일의 길이는 MaxBay*(Cell 크기 * Cell 간격) 수평 방향
      // 주행 레일의 상단 점
      //      시작 위치 + (호기-1) * (크레인 크기 + Rack간격) +(2*(호기-1)+1) * (Cell크기 + RailOffset) +
      //                  (크레인 크기 - RailHeight) div 2
      // Fitting Rack의 레일을 그린다.
      For i:= 1 to Fitting_MaxSc do
      Begin
         RailHeight := 3;
         RailWidth  := Fitting_size_rack_x * Fitting_MaxBay + size_space_bay * (Fitting_MaxBay - 1) + 2 * RailOffset + 16;
         RailTop    := Start_y + (2*(i-1) +1) * (Fitting_size_rack_y + RailOffset) +
                       (i-1) * (size_space_rack + Fitting_size_crane_y) + (Fitting_size_crane_y - RailHeight) div 2;
         RailLeft   := Start_x - RailOffset;

         // 레일을 그린다.
         Brush.Color := clBlack;
         Rectangle( RailLeft, RailTop, RailLeft + RailWidth, RailTop + RailHeight);

         // End Stopper을 그린다.
         Brush.Color := clYellow;
         Rectangle( RailLeft - 6, RailTop - 2, RailLeft, RailTop + RailHeight + 2);
         Rectangle( RailLeft + RailWidth, RailTop - 2, RailLeft + RailWidth + 6,
                    RailTop + RailHeight + 2);

      End;

      Pos_y := Start_y + Fitting_MaxSc * (size_space_rack + Fitting_size_crane_y) +
                         2 * Fitting_MaxSc * (Fitting_size_rack_y + RailOffset);

      // Profile Rack의 레일을 그린다.
      For i:= 1 to Profile_MaxSc do
      Begin
         RailHeight := 3;
         RailWidth  := Profile_size_rack_x * Profile_MaxBay + size_space_bay * (Profile_MaxBay - 1) + 2 * RailOffset + 16;
         RailTop    := Pos_y + (2*(i-1) +1) * (Profile_size_rack_y + RailOffset) +
                       (i-1) * (size_space_rack + Profile_size_crane_y) + (Profile_size_crane_y - RailHeight) div 2;
         RailLeft   := Start_x - RailOffset;

         // 레일을 그린다.
         Brush.Color := clBlack;
         Rectangle( RailLeft, RailTop, RailLeft + RailWidth, RailTop + RailHeight);

         // End Stopper을 그린다.
         Brush.Color := clYellow;
         Rectangle( RailLeft - 6, RailTop - 2, RailLeft, RailTop + RailHeight + 2);
         Rectangle( RailLeft + RailWidth, RailTop - 2, RailLeft + RailWidth + 6,
                    RailTop + RailHeight + 2);

      End;

      Brush.Color := $00EEE093;
      pos_x := start_x + RailOffset;
      pos_y := start_y;
      // Fitting Rack을 그린다.
      for Crane := 1 to Fitting_MaxSc do
      Begin
         for Bank := 1 to 2 do
         Begin
            Pos_y := Pos_y + (bank - 1) * Fitting_size_rack_y + (2*(bank-1)) * RailOffset;

            for Bay := 1 to Fitting_MaxBay do
            Begin
               if (bank = 1) and(Bay > 36) then continue;
               Pos_x := start_x + RailOffset + (bay - 1) * (Fitting_size_rack_x + size_space_bay);
               Rectangle(Pos_x, Pos_y, Pos_x + Fitting_size_rack_x, Pos_y + Fitting_size_rack_y);
               if (bank = 1) then
               begin
                  Font.Size := 6;
                  Font.Color := clBlue;
                  TextOut(pos_x + 1, pos_y + 8, IntToStr(Fitting_MaxBay - Bay + 1));
               end;
            End;
            pos_y := pos_y + (bank - 1) * size_space_rack;
            pos_y := pos_y + Fitting_size_crane_y;
         End;                // End of For Bank
      End;                   // End of For Crane

      Pos_y := Start_y + Fitting_MaxSc * (size_space_rack + Fitting_size_crane_y) +
                         2 * Fitting_MaxSc * (Fitting_size_rack_y + RailOffset);

      // Profile Rack을 그린다.
      for Crane := 1 to Profile_MaxSc do
      Begin
         for Bank := 1 to 2 do
         Begin
            Pos_y := Pos_y + (bank - 1) * Profile_size_rack_y + (2*(bank-1)) * RailOffset;

            for Bay := 1 to Profile_MaxBay - 1 do
            Begin
               if (bank = 1) and(Bay > 36) then continue;
               Pos_x := start_x + RailOffset + (bay - 1) * (Profile_size_rack_x + size_space_bay);
               Rectangle(Pos_x, Pos_y, Pos_x + Profile_size_rack_x, Pos_y + Profile_size_rack_y);
               if (Crane = 3) and (bank = 2) then
               begin
                  Font.Size := 6;
                  Font.Color := clBlue;
                  TextOut(pos_x + 1, pos_y + 8, IntToStr(Profile_MaxBay - Bay + 1));
               end;
            End;
            pos_y := pos_y + (bank - 1) * size_space_rack;
            pos_y := pos_y + Profile_size_crane_y;
         End;                // End of For Bank
      End;                   // End of For Crane

   End;
End;
end.
