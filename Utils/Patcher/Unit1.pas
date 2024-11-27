unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, ClipBrd, ComCtrls;

type
  TMain = class(TForm)
    Button1: TButton;
    OriginalLineEdit: TEdit;
    OwnLineEdit: TEdit;
    Label1: TLabel;
    SizeFirstLineLbl: TLabel;
    SizeSecondLineLbl: TLabel;
    PathEdt: TEdit;
    ListBox1: TListBox;
    RefreshBtn: TButton;
    ListBox2: TListBox;
    ToHexBtn: TButton;
    FileNameEdt: TEdit;
    CopyBtn: TButton;
    CopyBtn2: TButton;
    Label2: TLabel;
    CopyHexBtn: TButton;
    ReturnStrsBtn: TButton;
    Button8: TButton;
    ProgressBar1: TProgressBar;
    RemSpaces: TButton;
    AddSpaces: TButton;
    SaveStrsBtn: TButton;
    ReturnStrs2Btn: TButton;
    Label3: TLabel;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure OwnLineEditChange(Sender: TObject);
    procedure RefreshBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure ToHexBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure CopyBtn2Click(Sender: TObject);
    procedure CopyHexBtnClick(Sender: TObject);
    procedure ReturnStrsBtnClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure OriginalLineEditChange(Sender: TObject);
    procedure RemSpacesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddSpacesClick(Sender: TObject);
    procedure SaveStrsBtnClick(Sender: TObject);
    procedure ReturnStrs2BtnClick(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    function ReadTableCharToByte(Str: string): byte;
    function WriteTableCharToByte(Str: string): byte;
    { Private declarations }
  public
    procedure CheckSameLines;
    { Public declarations }
  end;

type
  PByteArray = ^TByteArray;
  TByteArray = array of Byte;

var
  Main: TMain;
  TableRead, TableWrite: TStringList;

  TempBufStr1, TempBufStr2: string;
  StrLine1, StrLine2: string;

  OSLang: string;

implementation

{$R *.dfm}

function BytesToStr(bytes: array of byte): string;
const
  BytesHex: array[0..15] of char = 
    ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
var
  i, len: integer;
begin
  len := Length(bytes);
  SetLength(Result, len * 2);
  for i := 0 to len - 1 do begin
    Result[i * 2 + 1] := BytesHex[bytes[i] shr 4];
    Result[i * 2 + 2] := BytesHex[bytes[i] and $0F];
  end;
end;

function RemoveBrackets(const InputString: string): string;
var
  OutputString: string;
  InsideBrackets: Boolean;
  i: Integer;
begin
  OutputString := '';
  InsideBrackets := False;

  for i := 1 to Length(InputString) do
  begin
    if InputString[i] = '{' then
    begin
      InsideBrackets := True;
    end
    else if InputString[i] = '}' then
    begin
      InsideBrackets := False;
    end
    else if not InsideBrackets then
    begin
      OutputString := OutputString + InputString[i];
    end;
  end;

  Result := OutputString;
end;

function GetLang: string;
var
  pcLCA: array [0..20] of Char;
begin
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SENGLANGUAGE, pcLCA, 19) <= 0 then
    pcLCA[0]:=#0;
  Result:=pcLCA;
end;

procedure TMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  SR: TSearchRec;
  i: integer;
  LastFile: string;
begin
  TableRead:=TStringList.Create;
  TableWrite:=TStringList.Create;
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  PathEdt.Text:=Ini.ReadString('Main', 'Path', '');
  TableRead.LoadFromFile(Ini.ReadString('Main', 'ReadTable', ''));
  TableWrite.LoadFromFile(Ini.ReadString('Main', 'WriteTable', ''));
  LastFile:=Ini.ReadString('Main', 'LastFile', '');
  Ini.Free;

  RefreshBtn.Click;

  for i:=0 to ListBox1.Items.Count - 1 do
    if LastFile = ListBox1.Items.Strings[i] then begin
      ListBox1.ItemIndex:=i;
      break;
    end;

  OSLang:=GetLang;

  if OSLang <> 'Russian' then begin
    Caption:='Translation Dino Crisis';
    RefreshBtn.Caption:='Refresh';
    CopyBtn.Caption:='Copy';
    CopyHexBtn.Caption:='Copy Hex';
    ReturnStrsBtn.Caption:='Return';
    SaveStrsBtn.Caption:='Save';
    ReturnStrs2Btn.Caption:='Restore';
    ToHexBtn.Caption:='To Hex';
    CopyBtn2.Caption:=CopyBtn.Caption;
    RemSpaces.Caption:='Remove spaces';
    AddSpaces.Caption:='Add spaces';
  end;

  Application.Title:=Caption;

  ListBox1Click(Sender);
end;

function TMain.ReadTableCharToByte(Str: string): byte;
var
  i: integer;
begin
  Result:=$00;
  for i:=0 to TableRead.Count - 1 do
    if (Copy(TableRead.Strings[i], 4, 1) = Str) then begin
      Result:=StrToInt('$' + Copy(TableRead.Strings[i], 1, 2));
      break;
    end;
end;

function TMain.WriteTableCharToByte(Str: string): byte;
var
  i: integer;
begin
  Result:=$00;
  for i:=0 to TableWrite.Count - 1 do
    if (Copy(TableWrite.Strings[i], 4, 1) = Str) then begin
      Result:=StrToInt('$' + Copy(TableWrite.Strings[i], 1, 2));
      break;
    end;
end;

function StrToBytesTBRead(Str: string): string;
var
  i, j: integer; KeyBytes, BytesValue: string; NotFound: boolean;
begin

  Result:='';

  for i:=1 to Length(Str) do begin
    NotFound:=true;
    for j:=0 to TableRead.Count - 1 do begin
      KeyBytes:=Copy(TableRead.Strings[j], 1, Pos('=', TableRead.Strings[j]) - 1);
      BytesValue:=Copy(TableRead.Strings[j], Length(KeyBytes) + 2, Length(TableRead.Strings[j]) - Length(KeyBytes) - 1);

      if Str[i] = BytesValue then begin
        Result:=Result + KeyBytes;
        NotFound:=false;
        break;
      end;
    end;


    if NotFound then
      if OSLang = 'Russian' then
        ShowMessage('Буква не найдена во ReadTable: ' + Str[i])
      else
        ShowMessage('Letter not found in ReadTable: ' + Str[i]);

  end;
end;

function StrToBytesTBWrite(Str: string): string;
var
  i, j: integer; KeyBytes, BytesValue: string; NotFound: boolean;
begin
  Result:='';


  for i:=1 to Length(Str) do begin
    NotFound:=true;
    for j:=0 to TableWrite.Count - 1 do begin
      KeyBytes:=Copy(TableWrite.Strings[j], 1, Pos('=', TableWrite.Strings[j]) - 1);
      BytesValue:=Copy(TableWrite.Strings[j], Length(KeyBytes) + 2, Length(TableWrite.Strings[j]) - Length(KeyBytes) - 1);

      if Str[i] = BytesValue then begin
        Result:=Result + KeyBytes;
        NotFound:=false;
        break;
      end;
    end;

    if NotFound then
      if OSLang = 'Russian' then
        ShowMessage('Буква не найдена во WriteTable: ' + Str[i])
      else
        ShowMessage('Letter not found in WriteTable: ' + Str[i]);
  end;
end;

function HexToBytes(const hex: string): TByteArray;
var
  i: Integer;
begin
  Assert(Length(hex) mod 2 = 0, 'Hex string length must be even');
  
  SetLength(Result, Length(hex) div 2);
  for i := 1 to Length(hex) div 2 do
  begin
    Result[i - 1] := StrToInt('$' + Copy(hex, (i - 1) * 2 + 1, 2));
  end;
end;

procedure TMain.Button1Click(Sender: TObject);
var
  InputFile: file of byte;
  CurByte: byte;
  i, Line: integer;
  FileStr: string;

  byteArray: TByteArray;
  fileStream: TFileStream;
begin
  //oldArray := HexToBytes(StrToBytesTBRead('Files'));
  //newArray := HexToBytes(StrToBytesTBWrite('Бумаг'));

  //

  FileStr:='';
  AssignFile(InputFile, ExtractFilePath(ParamStr(0)) + 'ST103-orig.diff');
  Reset(InputFile);
  for i:=0 to FileSize(InputFile) - 1 do begin
    Seek(InputFile, i);
    Read(InputFile, CurByte);
    FileStr:=BytesToStr(CurByte) + FileStr;
  end;
  CloseFile(InputFile);

  byteArray := HexToBytes( StringReplace(FileStr, StrToBytesTBRead('File'), StrToBytesTBWrite('Бума'), []) );
  fileStream := TFileStream.Create(ExtractFilePath(ParamStr(0)) + 'ST103.diff', fmCreate);
  try
    fileStream.Write(byteArray[0], Length(byteArray));
  finally
    fileStream.Free;
  end;
end;

procedure TMain.Button2Click(Sender: TObject);
begin
  if OSLang = 'Russian' then
    MessageBox(0, 'Версия программы: 27.11.24' + #13#10 + 'Автор: CasperPRO', 'Патчер', MB_ICONINFORMATION)
  else
    MessageBox(0, 'Version: 27.11.24' + #13#10 + 'Author: CasperPRO', 'Patcher', MB_ICONINFORMATION);
end;


procedure TMain.OwnLineEditChange(Sender: TObject);
begin
  CheckSameLines;
end;

procedure TMain.CheckSameLines;
begin
  if Length(OriginalLineEdit.Text) <> Length(OwnLineEdit.Text) then begin
    Label1.Font.Color:=clRed;
    if OSLang = 'Russian' then
      Label1.Caption:='Строки разные'
    else
      Label1.Caption:='The lines are different';
  end else begin
    Label1.Font.Color:=clGreen;
    if OSLang = 'Russian' then
      Label1.Caption:='Строки одинаковые'
    else
      Label1.Caption:='The lines are the same';
  end;
  SizeFirstLineLbl.Caption:=IntToStr(Length(OriginalLineEdit.Text));
  SizeSecondLineLbl.Caption:=IntToStr(Length(OwnLineEdit.Text));
end;

procedure TMain.RefreshBtnClick(Sender: TObject);
var
  SR: TSearchRec; i: integer; Dir: string;
begin
  ListBox1.Clear;
  Dir:=PathEdt.Text;
  if Dir[Length(Dir)] <> '\' then Dir:=Dir + '\';

  //Поиск файлов
  if FindFirst(Dir + '*.txt', faAnyFile, SR) = 0 then begin
    repeat
      Application.ProcessMessages;
      if (SR.Name <> '.') and (SR.Name <> '..') then
        if (SR.Attr and faDirectory) <> faDirectory then begin

            ListBox1.Items.Add(SR.Name);

        end;


    until FindNext(SR) <> 0;

  end;
  FindClose(SR);
  ProgressBar1.Max:=ListBox1.Items.Count - 1;
end;

function LoadTextFile(const FileName: string): string;
var
  Strings: TStringList;
begin
  Strings := TStringList.Create;
  try
    try
      Strings.LoadFromFile(FileName, TEncoding.UTF8);
    except
      Strings.LoadFromFile(FileName);
    end;
    Result:=Strings.Text;
  finally
    Strings.Free;
  end;
end;

procedure TMain.ListBox1Click(Sender: TObject);
begin
  if ListBox1.ItemIndex = -1 then Exit;
  ListBox2.Items.Text:=LoadTextFile(PathEdt.Text + ListBox1.Items.Strings[ListBox1.ItemIndex]);
  FileNameEdt.Text:=ListBox1.Items.Strings[ListBox1.ItemIndex];
  ProgressBar1.Position:=ListBox1.ItemIndex;
  if OSLang = 'Russian' then
    Caption:='Перевод Dino Crisis '
  else
    Caption:='Translation Dino Crisis ';
  Caption:=Caption + FloatToStr((ListBox1.ItemIndex + 1) * 100 div ListBox1.Items.Count) + '%';
end;

procedure TMain.ListBox2Click(Sender: TObject);
var
  i: integer;
begin
  if (ListBox2.ItemIndex = -1) or (ListBox2.ItemIndex = ListBox2.Count) or (ListBox2.ItemIndex = ListBox2.Count - 1) then Exit;

  Label3.Caption:=IntToStr(ListBox2.ItemIndex + 1);

  ListBox2.Items.Strings[ListBox2.ItemIndex]:=StringReplace(ListBox2.Items.Strings[ListBox2.ItemIndex], '{--}', '/', [rfReplaceAll]);
  if Pos('/', ListBox2.Items.Strings[ListBox2.ItemIndex]) > 0 then begin
    if OSLang = 'Russian' then
      Label2.Caption:='Ручное редактирование'
    else
      Label2.Caption:='Manual editing';

    Label2.Font.Color:=clRed;
  end else begin
    if OSLang = 'Russian' then
      Label2.Caption:='Авто вставка'
    else
      Label2.Caption:='Auto insert';
    Label2.Font.Color:=clGreen;
  end;

  if ListBox2.Items.Strings[ListBox2.ItemIndex][1] = '{' then begin
    ListBox2.Items.Strings[ListBox2.ItemIndex]:=StringReplace(ListBox2.Items.Strings[ListBox2.ItemIndex], '\n', '\', [rfReplaceAll]);
    //ListBox2.Items.Strings[ListBox2.ItemIndex]:=StringReplace(ListBox2.Items.Strings[ListBox2.ItemIndex], '{$1001}', '', [rfReplaceAll]);
    //ListBox2.Items.Strings[ListBox2.ItemIndex]:=StringReplace(ListBox2.Items.Strings[ListBox2.ItemIndex], '{$2000}', '', [rfReplaceAll]);
    //ListBox2.Items.Strings[ListBox2.ItemIndex]:=StringReplace(ListBox2.Items.Strings[ListBox2.ItemIndex], '{--}', '', [rfReplaceAll]);
    //ListBox2.Items.Strings[ListBox2.ItemIndex]:=StringReplace(ListBox2.Items.Strings[ListBox2.ItemIndex], '{$0800}', '', [rfReplaceAll]);
    ListBox2.Items.Strings[ListBox2.ItemIndex]:=RemoveBrackets(ListBox2.Items.Strings[ListBox2.ItemIndex]);

    ListBox2.Items.Strings[ListBox2.ItemIndex + 1]:=StringReplace(ListBox2.Items.Strings[ListBox2.ItemIndex + 1], '\n', '\', [rfReplaceAll]);
    //ListBox2.Items.Strings[ListBox2.ItemIndex + 1]:=StringReplace(ListBox2.Items.Strings[ListBox2.ItemIndex + 1], '{$1001}', '', [rfReplaceAll]);
    //ListBox2.Items.Strings[ListBox2.ItemIndex + 1]:=StringReplace(ListBox2.Items.Strings[ListBox2.ItemIndex + 1], '{$2000}', '', [rfReplaceAll]);
    //ListBox2.Items.Strings[ListBox2.ItemIndex + 1]:=StringReplace(ListBox2.Items.Strings[ListBox2.ItemIndex + 1], '{--}', '', [rfReplaceAll]);
    //ListBox2.Items.Strings[ListBox2.ItemIndex + 1]:=StringReplace(ListBox2.Items.Strings[ListBox2.ItemIndex + 1], '{$0800}', '', [rfReplaceAll]);
    ListBox2.Items.Strings[ListBox2.ItemIndex + 1]:=RemoveBrackets(ListBox2.Items.Strings[ListBox2.ItemIndex + 1]);
  end;

  OriginalLineEdit.Text:=ListBox2.Items.Strings[ListBox2.ItemIndex];
  OwnLineEdit.Text:=ListBox2.Items.Strings[ListBox2.ItemIndex + 1];

  if Length(OwnLineEdit.Text) < Length(OriginalLineEdit.Text) then
    for i:=1 to Length(OriginalLineEdit.Text)- Length(OwnLineEdit.Text) do
      OwnLineEdit.Text:=OwnLineEdit.Text + ' ';

  //OriginalLineEdit.Text:=StrToBytesTBRead(ListBox2.Items.Strings[ListBox2.ItemIndex]);
  //OwnLineEdit.Text:=StrToBytesTBWrite(ListBox2.Items.Strings[ListBox2.ItemIndex + 1]);
  
  //OriginalLineEdit.Text:=StrToBytesTBRead('Files are scattered.');
  //OwnLineEdit.Text:=StrToBytesTBWrite('Бумаги разбросаны  .');
end;

procedure TMain.ToHexBtnClick(Sender: TObject);
begin
  TempBufStr1:=OriginalLineEdit.Text;
  TempBufStr2:=OwnLineEdit.Text;
  OriginalLineEdit.Text:=StrToBytesTBRead(OriginalLineEdit.Text);
  OwnLineEdit.Text:=StrToBytesTBWrite(OwnLineEdit.Text);
end;

procedure TMain.CopyBtnClick(Sender: TObject);
begin
  ClipBoard.AsText:=OriginalLineEdit.Text;
  OriginalLineEdit.Text:='';
end;

procedure TMain.CopyBtn2Click(Sender: TObject);
begin
  ClipBoard.AsText:=OwnLineEdit.Text;
  OwnLineEdit.Text:='';
end;

procedure TMain.CopyHexBtnClick(Sender: TObject);
begin
  ClipBoard.AsText:=StrToBytesTBRead(OriginalLineEdit.Text);
end;

procedure TMain.ReturnStrsBtnClick(Sender: TObject);
begin
  OriginalLineEdit.Text:=TempBufStr1;
  OwnLineEdit.Text:=TempBufStr2;
end;

procedure TMain.Button8Click(Sender: TObject);
var
  //InputFile, OutputFile: file of byte;
  //CurByte, CurByte2: byte;
  //i: integer;

  FileStr: string;

  InputFile, OutputFile: TFileStream;
  Buffer: array[0..1] of Byte;


  oldArray, newArray: TByteArray;

  FoundFirstSymb: boolean;
  SymbMatch: integer;
begin
  //ABCDE___A
  //Тест12

  oldArray := HexToBytes(StrToBytesTBRead('AB'));
  newArray := HexToBytes(StrToBytesTBWrite('Те'));

  SymbMatch:=0;
  FoundFirstSymb:=false;

  InputFile := TFileStream.Create('test ABCDE__A.bin', fmOpenRead);
  OutputFile := TFileStream.Create('test Тест12.bin', fmCreate);
  try
    while InputFile.Read(Buffer, SizeOf(Buffer)) > 0 do
      begin
        {if FoundFirstSymb



        if (oldArray[0] = Buffer[0]) and (oldArray[1] = Buffer[1]) then begin // Первый символ схожий
          FoundFirstSymb:=true;
          SymbMatch:=1;
          //ShowMessage(IntToHex(Buffer[0], 2) + IntToHex(Buffer[1], 2));

        end;   }



        //OutputFile.Write(Buffer, SizeOf(Buffer));

      end;
    finally
      InputFile.Free;
      OutputFile.Free;
    end;


{
var
  oldArray, newArray: TByteArray;

  fileStream, fileStream2: TFileStream;
  buffer1: TByteArray;
  bytesRead: Integer;
begin
  oldArray := HexToBytes(StrToBytesTBRead('Files'));
  newArray := HexToBytes(StrToBytesTBWrite('Бумаг'));

  //
  fileStream2 := TFileStream.Create(ExtractFilePath(ParamStr(0)) + 'ST103.diff', fmCreate); // Открываем файл для записи

  fileStream := TFileStream.Create(ExtractFilePath(ParamStr(0)) + 'ST103-orig.diff', fmOpenRead);
  try
    SetLength(buffer1, Length(oldArray));

    repeat
      bytesRead := fileStream.Read(buffer1[0], Length(oldArray));

      if (bytesRead > 0) then
      begin
        // Сравниваем байты
        if CompareMem(@buffer1[0], @oldArray[0], bytesRead) then
        begin
          ShowMessage('Найдено');
          // Блоки совпадают
          fileStream2.Write(newArray[0], Length(newArray));
        end
        else
        begin
          // Блоки различаются
          fileStream2.Write(buffer1[0], bytesRead);
        end;
      end;
    until (bytesRead <= 0);
  finally
    fileStream.Free;
    fileStream2.Free;
  end;
}
end;

procedure TMain.OriginalLineEditChange(Sender: TObject);
begin
  CheckSameLines;
end;

procedure TMain.RemSpacesClick(Sender: TObject);
begin
  OwnLineEdit.Text := TrimRight(OwnLineEdit.Text);
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini: TIniFile;
begin
  if ListBox1.ItemIndex = -1 then Exit;
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  Ini.WriteString('Main', 'LastFile', ListBox1.Items.Strings[ListBox1.ItemIndex]);
  Ini.Free;
end;

procedure TMain.AddSpacesClick(Sender: TObject);
var
  i: integer;
begin
  if Length(OwnLineEdit.Text) < Length(OriginalLineEdit.Text) then
    for i:=1 to Length(OriginalLineEdit.Text)- Length(OwnLineEdit.Text) do
      OwnLineEdit.Text:=OwnLineEdit.Text + ' ';
end;

procedure TMain.SaveStrsBtnClick(Sender: TObject);
begin
  StrLine1:=OriginalLineEdit.Text;
  StrLine2:=OwnLineEdit.Text;
end;

procedure TMain.ReturnStrs2BtnClick(Sender: TObject);
begin
  OriginalLineEdit.Text:=StrLine1;
  OwnLineEdit.Text:=StrLine2;
end;

procedure TMain.Label3Click(Sender: TObject);
var
  Value: integer;
begin
  Value:=StrToInt(Label3.Caption);
  if Value < ListBox2.Count then
    ListBox2.ItemIndex:=Value - 1;
end;

end.
