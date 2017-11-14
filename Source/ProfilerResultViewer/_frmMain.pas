unit _frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, VirtualTrees, Buttons;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    btnOpenViewer: TBitBtn;
    lbItems: TListBox;
    edtDir: TEdit;
    btnBrowseDir: TButton;
    procedure edtDirChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOpenViewerClick(Sender: TObject);
    procedure lbItemsDblClick(Sender: TObject);
    procedure btnBrowseDirClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTreeItems(const aDir: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  JclFileUtils,
  _frmResults,
  _uProfilerManager,
  Winapi.ShellAPI,
  Vcl.FileCtrl;

{$R *.dfm}

function BuildFileList(const Path: string; const Attr: Integer;
  const List: TStrings; const FileMask: string; const aExportFullFilenames: boolean = false): Boolean;
const
  {$IFDEF LINUX}
    PathSeparator    = '/';
  {$ENDIF LINUX}
  {$IFDEF MSWINDOWS}
    PathSeparator    = '\';
  {$ENDIF MSWINDOWS}
var
  srSearchRec: TSearchRec;
  iResult: Integer;
  sPath, sFileName: string;
  //dFileName: TDate;
begin
  Assert(List <> nil);
  sPath := Path;

  { Append path delimiter if necessary. }
  if (Length(sPath) = 0) or (AnsiLastChar(sPath) <> PathSeparator) then
    sPath := sPath + PathSeparator;

  iResult := FindFirst(sPath + '*.*', Attr, srSearchRec);
  Result := iResult = 0;
  try
    if Result then
    begin
      while iResult = 0 do
      begin
        if (srSearchRec.Name <> '.') and (srSearchRec.Name <> '..') and
           ( ((srSearchRec.Attr and Attr) <> 0) or
             (srSearchRec.Attr >= 128)) then
        begin
          if srSearchRec.Attr = faDirectory then
          begin
            sFileName := sPath + srSearchRec.Name;
            BuildFileList(sFileName, Attr, List, FileMask, aExportFullFilenames)
          end
          else
          begin
            sFileName := srSearchRec.Name;
            if aExportFullFilenames then
              sFileName := sPath + sFileName;

            //am: stupid fix for Windows bug! If you search for *.100 you also get files with *.1003 etc!
            if LowerCase(ExtractFileExt(sFilename)) = LowerCase(ExtractFileExt(FileMask)) then
            begin
              List.Add(sFileName);
            end
            else if ExtractFileExt(FileMask) = '' then
            begin
              List.Add(sFileName);
            end;
          end;
        end;
        iResult := FindNext(srSearchRec);
      end;
      Result := iResult = ERROR_NO_MORE_FILES;
    end;
  finally
    SysUtils.FindClose(srSearchRec);
  end;
end;

procedure TfrmMain.edtDirChange(Sender: TObject);
begin
  LoadTreeItems(edtDir.Text);
end;

procedure TfrmMain.LoadTreeItems(const aDir: string);
var
  str: Tstrings;
begin
  lbItems.Clear;
  if not SysUtils.DirectoryExists(aDir) then exit;

  str := TStringlist.Create;
  if BuildFileList(aDir, faAnyFile, str, '*.profilerun', True) then
  begin
     lbItems.Items.Text := str.Text;
  end;
  str.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  edtDir.Text := ExtractFilePath(Application.ExeName);
end;

procedure TfrmMain.btnBrowseDirClick(Sender: TObject);
var
  dir : string;
begin
  dir := edtDir.Text;

  if SelectDirectory('Select a folder', '', dir, [sdNewUI], self) then begin
    edtDir.Text := dir;
  end;

end;

procedure TfrmMain.btnOpenViewerClick(Sender: TObject);
var
  i:integer;
  s:string;
  frmResults : TfrmResults;
  pr: TProfileRun ;
begin
  i := lbItems.ItemIndex;
  if i < 0 then exit;
  s := lbItems.Items[i];
  if FileExists(s) then
  begin
    pr := TProfileRun.Create;
    pr.LoadFromFile(s);
    pr.LoadProfileTimesFromDir( ExtractFilePath(s) );
    frmResults := TfrmResults.Create(nil);
    try
      frmResults.Profilerun := pr;
      if frmResults.ShowModal = mrOk then ;
    finally
      frmResults.Free;
    end;
  end;
end;

procedure TfrmMain.lbItemsDblClick(Sender: TObject);
begin
  btnOpenViewer.Click;
end;

end.
