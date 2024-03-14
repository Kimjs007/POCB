object TDiTestForm: TTDiTestForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'TDiTestForm'
  ClientHeight = 586
  ClientWidth = 207
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tmrUpdate: TTimer
    Interval = 100
    OnTimer = tmrUpdateTimer
    Left = 168
    Top = 8
  end
end
