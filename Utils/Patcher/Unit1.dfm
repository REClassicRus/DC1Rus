object Main: TMain
  Left = 192
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1077#1088#1077#1074#1086#1076' Dino Crisis'
  ClientHeight = 470
  ClientWidth = 831
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 390
    Width = 3
    Height = 13
    Caption = '-'
  end
  object SizeFirstLineLbl: TLabel
    Left = 813
    Top = 363
    Width = 6
    Height = 13
    Caption = '0'
  end
  object SizeSecondLineLbl: TLabel
    Left = 813
    Top = 418
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label2: TLabel
    Left = 136
    Top = 390
    Width = 3
    Height = 13
    Caption = '-'
  end
  object Label3: TLabel
    Left = 800
    Top = 13
    Width = 6
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = '0'
    ParentBiDiMode = False
    OnClick = Label3Click
  end
  object Button1: TButton
    Left = 728
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object OriginalLineEdit: TEdit
    Left = 8
    Top = 360
    Width = 801
    Height = 21
    TabOrder = 1
    OnChange = OriginalLineEditChange
  end
  object OwnLineEdit: TEdit
    Left = 8
    Top = 415
    Width = 801
    Height = 21
    TabOrder = 2
    OnChange = OwnLineEditChange
  end
  object PathEdt: TEdit
    Left = 8
    Top = 9
    Width = 705
    Height = 21
    TabOrder = 3
  end
  object ListBox1: TListBox
    Left = 8
    Top = 40
    Width = 169
    Height = 265
    ItemHeight = 13
    TabOrder = 4
    OnClick = ListBox1Click
  end
  object RefreshBtn: TButton
    Left = 719
    Top = 7
    Width = 75
    Height = 25
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    TabOrder = 5
    OnClick = RefreshBtnClick
  end
  object ListBox2: TListBox
    Left = 184
    Top = 40
    Width = 649
    Height = 313
    ItemHeight = 13
    TabOrder = 6
    OnClick = ListBox2Click
  end
  object ToHexBtn: TButton
    Left = 7
    Top = 439
    Width = 100
    Height = 25
    Caption = #1042' HEX'
    TabOrder = 7
    OnClick = ToHexBtnClick
  end
  object FileNameEdt: TEdit
    Left = 8
    Top = 310
    Width = 169
    Height = 21
    TabOrder = 8
  end
  object CopyBtn: TButton
    Left = 266
    Top = 384
    Width = 100
    Height = 25
    Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 9
    OnClick = CopyBtnClick
  end
  object CopyBtn2: TButton
    Left = 266
    Top = 439
    Width = 100
    Height = 25
    Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 10
    OnClick = CopyBtn2Click
  end
  object CopyHexBtn: TButton
    Left = 368
    Top = 384
    Width = 100
    Height = 25
    Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' HEX'
    TabOrder = 11
    OnClick = CopyHexBtnClick
  end
  object ReturnStrsBtn: TButton
    Left = 470
    Top = 384
    Width = 107
    Height = 25
    Caption = #1042#1086#1079#1074#1088#1072#1090
    TabOrder = 12
    OnClick = ReturnStrsBtnClick
  end
  object Button8: TButton
    Left = 630
    Top = 442
    Width = 75
    Height = 25
    Caption = #1058#1077#1089#1090' '#1087#1072#1090#1095
    TabOrder = 13
    Visible = False
    OnClick = Button8Click
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 336
    Width = 169
    Height = 17
    TabOrder = 14
  end
  object RemSpaces: TButton
    Left = 368
    Top = 439
    Width = 100
    Height = 25
    Caption = #1059#1073#1088#1072#1090#1100' '#1087#1088#1086#1073#1077#1083#1099
    TabOrder = 15
    OnClick = RemSpacesClick
  end
  object AddSpaces: TButton
    Left = 470
    Top = 439
    Width = 105
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1086#1073#1077#1083#1099
    TabOrder = 16
    OnClick = AddSpacesClick
  end
  object SaveStrsBtn: TButton
    Left = 605
    Top = 384
    Width = 100
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 17
    OnClick = SaveStrsBtnClick
  end
  object ReturnStrs2Btn: TButton
    Left = 709
    Top = 384
    Width = 100
    Height = 25
    Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
    TabOrder = 18
    OnClick = ReturnStrs2BtnClick
  end
  object Button2: TButton
    Left = 776
    Top = 442
    Width = 30
    Height = 25
    Caption = '?'
    TabOrder = 19
    OnClick = Button2Click
  end
end
