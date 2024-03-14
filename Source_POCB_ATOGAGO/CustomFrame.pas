unit CustomFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TCustomFrame = class(TFrame)
  private
    { Private declarations }
  public
    procedure ReconfigGui; virtual; abstract; //2022-07-15 A2CHv4_#3(FanInOutPC)
    procedure UpdateGui(var sMsg : string); virtual; abstract;
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
