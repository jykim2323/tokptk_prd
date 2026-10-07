object DM1: TDM1
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Left = 62
  Top = 165
  Height = 474
  Width = 583
  object Main_db: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=Y0h9t3e0%;Persist Security Info=Tru' +
      'e;User ID=wms_db_user;Initial Catalog=Tokstk_db;Data Source=wmsd' +
      'b01;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=' +
      '4096;Workstation ID=JPLUSPC02;Use Encryption for Data=False;Tag ' +
      'with column collation when possible=False'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 112
    Top = 136
  end
  object SaveDialog: TSaveDialog
    Left = 192
    Top = 136
  end
end
