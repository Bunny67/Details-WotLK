local L = LibStub("AceLocale-3.0"):NewLocale("Details_DeathGraphs", "koKR")
if not L then return end

L["STRING_BRESS"] = "전투 부활"
L["STRING_DEATH_DESC"] = "플레이어 죽음을 포함한 창을 표시합니다."
L["STRING_DEATHS"] = "죽음"
L["STRING_ENCOUNTER_MAXSEGMENTS"] = "현재 우두머리 전투 최대 세분화"
L["STRING_ENCOUNTER_MAXSEGMENTS_DESC"] = "'현재 우두머리 전투' 디스플레이에 저장할 세분화의 최대 갯수입니다."
L["STRING_ENDURANCE"] = "생존력"
L["STRING_ENDURANCE_DEATHS_THRESHOLD"] = "생존력 죽음 임계치"
L["STRING_ENDURANCE_DEATHS_THRESHOLD_DESC"] = "처음 사망한 |cFFFFFF00X|r명의 플레이어는 생존율을 잃습니다."
L["STRING_ENDURANCE_DESC"] = [=[생존력은 공격대 우두머리 전투 중 누가 더 오래 살아남는 지 알려주기 위한 개념적 점수입니다.

생존율은 첫번째 사망자만 고려하여 계산됩니다 ('|cFFFFDD00죽음 제한 설정|r'에서 구성 가능).]=]
L["STRING_FLAWLESS"] = "|cFF44FF44완벽한 플레이어!|r"
L["STRING_LATEST"] = "최근"
L["STRING_OPTIONS"] = "옵션"
L["STRING_OVERALL_DEATHS_THRESHOLD"] = "종합 죽음 임계치"
L["STRING_OVERALL_DEATHS_THRESHOLD_DESC"] = "처음 사망한 |cFFFFFF00X|r명의 플레이어는 종합 죽음에 등록됩니다."
L["STRING_OVERTIME"] = "초과 시간"
L["STRING_PLUGIN_DESC"] = [=[우두머리 전투 진행 중, 공격대원의 죽음을 수집하고 통계를 만듭니다.

- |cFFFFFFFF현재 우두머리 전투|r: |cFFFF9900마지막 세분화의 죽음을 표시합니다.

- |cFFFFFFFF시간선|r: |cFFFF9900우두머리의 약화 효과와 주문이 공격대원에게 언제 시전됐는 지를 알려주는 그래프를 표시하고 죽음이 발생한 시점을 나타내는 선을 그립니다.

- |cFFFFFFFF생존력|r: |cFFFF9900우두머리 전투에서 얼마나 오래 살아있었는지 나타내는 백분율과 함께 플레이어 명단을 표시합니다.

- |cFFFFFFFF종합|r: |cFFFF9900플레이어의 죽음과 죽기 전에 주문으로 받은 피해를 포함한 플레이어 명단을 유지합니다.]=]
L["STRING_PLUGIN_NAME"] = "고급 죽음 기록"
L["STRING_PLUGIN_WELCOME"] = [=[고급 죽음 기록에 오신 걸 환영합니다!


-|cFFFFFF00현재 우두머리 전투|r: 마지막 우두머리 전투에서의 죽음을 표시합니다, 기본값으로 마지막 2개 세분화의 죽음을 저장합니다, 옵션 창에서 세분화 갯수를 늘릴 수 있습니다.

- |cFFFFFF00시간선|r: 당신의 공격대 대부분이 죽은 시점을 표시하고, 적의 능력이 사용된 시간도 표시합니다.

- |cFFFFFF00생존력|r: 우두머리 전투 중 처음으로 죽은 사람의 플레이어 기술을 평가합니다, 기본값으로 처음 사망한 5명의 플레이어는 생존율을 잃습니다.

- |cFFFFFF00종합|r: 일반적인 죽음 기록과 더불어 플레이어의 사망 전 종합 받은 피해를 표시합니다.


- 오른쪽 마우스 버튼으로 클릭하면 언제든지 창을 닫을 수 있습니다!]=]
L["STRING_RESET"] = "데이터 초기화"
L["STRING_SURVIVAL"] = "생존"
L["STRING_TIMELINE_DEATHS_THRESHOLD"] = "시간선 죽음 임계치"
L["STRING_TIMELINE_DEATHS_THRESHOLD_DESC"] = "우두머리 전투 중 처음 사망한 |cFFFFFF00X|r명의 플레이어는 시간선 그래프에 표시하기 위해 등록됩니다."
L["STRING_TOOLTIP"] = "죽음 그래프 표시"
--[[Translation missing --]]
--[[ L["STRING_10NORMAL"] = ""--]]
--[[Translation missing --]]
--[[ L["STRING_10NORMAL_DESC"] = ""--]]
--[[Translation missing --]]
--[[ L["STRING_25NORMAL"] = ""--]]
--[[Translation missing --]]
--[[ L["STRING_25NORMAL_DESC"] = ""--]]
--[[Translation missing --]]
--[[ L["STRING_10HEROIC"] = ""--]]
--[[Translation missing --]]
--[[ L["STRING_10HEROIC_DESC"] = ""--]]
--[[Translation missing --]]
--[[ L["STRING_25HEROIC"] = ""--]]
--[[Translation missing --]]
--[[ L["STRING_25HEROIC_DESC"] = ""--]]
