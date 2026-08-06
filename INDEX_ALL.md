# 記憶索引 第二層（不自動載入）

🔴 這裡放的是「開場不一定會用到」的主題：投資、環境/系統設定、個人生活。
🔴 觸發時機：使用者一講到選股/看盤/持倉/信貸/記帳/旅遊/推播/hook/權限/跨裝置/模型選擇 —— 先讀本檔再回答。
🔴 MEMORY.md 查無某條規則時，不准直接說「沒有這條規則」，要先讀完本檔。

## 投資
- [持倉與觀察](portfolio_watchlist.md) — 2330+00981A(3189已賣),美股QQQM/NVDA
- [🔴80萬計畫](project_invest_80w_plan_0706.md) / [存30萬](project_savings_plan_30w.md) / [信貸100W](loan_investment_plan.md) / [信貸提問](reference_loan_question_checklist.md)
- [🔴🔴🔴崩盤接刀手冊](feedback_crash_playbook_0806.md) — 三鐵則(夠深/抱60天/分批不猜底)+先判2022型;跌越深反彈越大;GAP錯殺代理;落底日不可預測改深度刻度;金融股是避震器;崩盤後0050贏但對他=加倉;半導體反彈最弱
- [🔴🔴🔴推薦前必跑對照組](feedback_benchmark_comparison_required_0730.md) — 「買0050就好」推翻整套;前N名出口前加對照組
- [金融股資料庫](reference_financial_stocks_data_0730.md) — 除權息/填息率/PB在最貴端;TWT49U參數startDate
- [🔴🔴題1要逐檔查個股新聞](feedback_thesis1_needs_stock_specific_news.md) — 廣達GDS稀釋漏查吃-9.9%;跌最深≠能接
- [🔴法說好不是進場理由](feedback_earnings_call_not_entry_reason.md) — 後5日中位-0.24%輸基準17pp;等回檔
- [🔴停損紀律](feedback_stoploss_discipline_lessons_0720.md) — 同組兩檔觸停損整組出清
- [🔴TWSE抓法](reference_twse_api_same_day_data.md) — 當日別用STOCK_DAY_ALL;改RWD MI_INDEX;BWIBBU的PE在第3欄
- [🔴主線題材表(選股必看)](macro_themes.md) — 循環位置/已動未動/催化劑;飆股藏在復甦初期
- [全市場](reference_full_market_screen.md) / [評分](feedback_stock_selection_system.md) / [選股閘門](feedback_stock_completeness_gate.md) / [進場](reference_stock_entry_checklist.md) / [飆股洞察](feedback_flystock_lessons.md) / [集中度標註](feedback_concentration_flag_not_filter.md) / [無腦掛單](feedback_brainless_order_system.md)
- [🔴策略庫(查表)](reference_stock_strategy_library.md) — 20大策略+書籍雷達+課程要點+風險等級表;正本=選股說明.txt優先
- [框架完結](project_stock_framework_refactor.md) / [對帳制度](project_stock_track_record.md) / [模擬倉(停用)](project_paper_trading.md) / [課程教材](reference_trading_course_source.md)
- [分析師模板](feedback_stock_analyst_deep_dive.md) / [附股價時戳](feedback_always_show_price_with_timestamp.md) / [查法說日期](feedback_proactive_earnings_calendar.md) / [符號標反](reference_webfetch_price_sign_flip.md)
- [Mac海選](feedback_mac_vs_windows_stock_selection.md) `full_market_scan.py`+T86 selectType=ALL / [重心是錢](user_money_first_focus.md) 從ROI給數字絕不掰
- [0730崩盤留下的規則](project_market_crash_0730_state.md) — 2022-06型三項判定+分批至少過兩項+反彈日不等於止穩+待跑80萬試算(0717/AI七層兩快照已汰除)

## 環境/系統
- [🔴🔴模型/額度/派工手冊](reference_model_cost_and_dispatch_0806.md) — 切模型四層權限+中途切cache失效更貴;額度三筆(每輪注入最貴);規則層vs案件層;汰舊換新;派工三條件+🔴子代理禁動計價本/修改單本/交付檔;gate-dispatcher四層設計
- [🔴🔴盲測污染:寫進索引=案子永久燒掉](feedback_blindtest_system_reminder_contamination_0804.md) — 開場強制載入擋不掉;測試案索引只寫狀態別寫發現
- [三層權限政策](feedback_permission_tiers.md) — bypassPermissions+22條毀滅級deny
- [🔴跨裝置同步手冊](project_cross_device_setup.md) — repo=e55663/claude-stock-memory;三台對接雲端不需同時開;一律從Downloads\agent開(打cc);設定用symlink版控;Mac那套是重建版;Mac硬碟清理待辦 / [Statusline](reference_statusline_powershell_fix.md) / [agent自動](project_ai_agent_automation.md)
- [不要自動產獨立檔案](feedback_no_standalone_artifacts.md) — 選股結果直接講

## 個人生活
- [🔴使用者檔案](user_profile.md) — 羅慶人/營造業副主任/品管+主任牌;🔴月生活費週期23號到23號非日曆月;飲料預設無糖;海外要勸阻衝動購買;表格不要橫向捲動
- [個人待辦](reference_personal_todo_list.md) — 「幫我記一下」寫進;「我有什麼要做的」讀出
- [🔴巴黎刷卡順序](reference_paris_card_strategy_0730.md) — DAWHO2.5萬→星展1.5萬→富邦1.5萬→玉山UP選;拒DCC;數字清單在Downloads\個人\
- [推播](project_personal_todo_push_setup_0714.md) / [記帳Excel](project_budget_spreadsheet.md) / [信用卡](project_credit_card_optimization_2026.md) / [手環](project_luxury_bracelet_purchase_plan.md) / [Gucci](project_vintage_bag_valuation.md) / [巴黎](project_france_trip.md) / [IG](reference_ig_follower_compare.md)