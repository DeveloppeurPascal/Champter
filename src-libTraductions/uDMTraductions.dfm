object dmTraductions: TdmTraductions
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 226
  Width = 543
  object tabTextesTraduits: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 88
    Top = 56
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 168
    Top = 112
  end
end
