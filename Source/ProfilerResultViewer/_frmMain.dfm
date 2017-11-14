object frmMain: TfrmMain
  Left = 391
  Top = 330
  Caption = 'Profile Result Viewer'
  ClientHeight = 456
  ClientWidth = 734
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    734
    456)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 69
    Height = 13
    Caption = 'Application dir:'
  end
  object btnOpenViewer: TBitBtn
    Left = 8
    Top = 423
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Open viewer'
    TabOrder = 0
    OnClick = btnOpenViewerClick
  end
  object lbItems: TListBox
    Left = 8
    Top = 40
    Width = 718
    Height = 377
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = 1
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnDblClick = lbItemsDblClick
  end
  object edtDir: TEdit
    Left = 83
    Top = 8
    Width = 607
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'edtDir'
    OnChange = edtDirChange
  end
  object btnBrowseDir: TButton
    Left = 696
    Top = 8
    Width = 30
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 3
    OnClick = btnBrowseDirClick
  end
end
