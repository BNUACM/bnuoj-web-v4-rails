var I18n = I18n || {};
I18n.translations = {"en":{"date":{"formats":{"default":"%Y-%m-%d","short":"%b %d","long":"%B %d, %Y"},"day_names":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],"abbr_day_names":["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],"month_names":[null,"January","February","March","April","May","June","July","August","September","October","November","December"],"abbr_month_names":[null,"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"order":["year","month","day"]},"time":{"formats":{"default":"%a, %d %b %Y %H:%M:%S %z","short":"%d %b %H:%M","long":"%B %d, %Y %H:%M"},"am":"am","pm":"pm"},"support":{"array":{"words_connector":", ","two_words_connector":" and ","last_word_connector":", and "}},"number":{"format":{"separator":".","delimiter":",","precision":3,"significant":false,"strip_insignificant_zeros":false},"currency":{"format":{"format":"%u%n","unit":"$","separator":".","delimiter":",","precision":2,"significant":false,"strip_insignificant_zeros":false}},"percentage":{"format":{"delimiter":"","format":"%n%"}},"precision":{"format":{"delimiter":""}},"human":{"format":{"delimiter":"","precision":3,"significant":true,"strip_insignificant_zeros":true},"storage_units":{"format":"%n %u","units":{"byte":{"one":"Byte","other":"Bytes"},"kb":"KB","mb":"MB","gb":"GB","tb":"TB"}},"decimal_units":{"format":"%n %u","units":{"unit":"","thousand":"Thousand","million":"Million","billion":"Billion","trillion":"Trillion","quadrillion":"Quadrillion"}}}},"errors":{"format":"%{attribute} %{message}","messages":{"inclusion":"is not included in the list","exclusion":"is reserved","invalid":"is invalid","confirmation":"doesn't match %{attribute}","accepted":"must be accepted","empty":"can't be empty","blank":"can't be blank","present":"must be blank","too_long":"is too long (maximum is %{count} characters)","too_short":"is too short (minimum is %{count} characters)","wrong_length":"is the wrong length (should be %{count} characters)","not_a_number":"is not a number","not_an_integer":"must be an integer","greater_than":"must be greater than %{count}","greater_than_or_equal_to":"must be greater than or equal to %{count}","equal_to":"must be equal to %{count}","less_than":"must be less than %{count}","less_than_or_equal_to":"must be less than or equal to %{count}","other_than":"must be other than %{count}","odd":"must be odd","even":"must be even","taken":"has already been taken"}},"activerecord":{"errors":{"messages":{"record_invalid":"Validation failed: %{errors}","restrict_dependent_destroy":{"one":"Cannot delete record because a dependent %{record} exists","many":"Cannot delete record because dependent %{record} exist"}}}},"datetime":{"distance_in_words":{"half_a_minute":"half a minute","less_than_x_seconds":{"one":"less than 1 second","other":"less than %{count} seconds"},"x_seconds":{"one":"1 second","other":"%{count} seconds"},"less_than_x_minutes":{"one":"less than a minute","other":"less than %{count} minutes"},"x_minutes":{"one":"1 minute","other":"%{count} minutes"},"about_x_hours":{"one":"about 1 hour","other":"about %{count} hours"},"x_days":{"one":"1 day","other":"%{count} days"},"about_x_months":{"one":"about 1 month","other":"about %{count} months"},"x_months":{"one":"1 month","other":"%{count} months"},"about_x_years":{"one":"about 1 year","other":"about %{count} years"},"over_x_years":{"one":"over 1 year","other":"over %{count} years"},"almost_x_years":{"one":"almost 1 year","other":"almost %{count} years"}},"prompts":{"year":"Year","month":"Month","day":"Day","hour":"Hour","minute":"Minute","second":"Seconds"}},"helpers":{"select":{"prompt":"Please select"},"submit":{"create":"Create %{model}","update":"Update %{model}","submit":"Save %{model}"}},"will_paginate":{"previous_label":"\u0026#8592; Previous","next_label":"Next \u0026#8594;","page_gap":"\u0026hellip;","page_entries_info":{"single_page":{"zero":"No %{model} found","one":"Displaying 1 %{model}","other":"Displaying all %{count} %{model}"},"single_page_html":{"zero":"No %{model} found","one":"Displaying \u003Cb\u003E1\u003C/b\u003E %{model}","other":"Displaying \u003Cb\u003Eall\u0026nbsp;%{count}\u003C/b\u003E %{model}"},"multi_page":"Displaying %{model} %{from} - %{to} of %{count} in total","multi_page_html":"Displaying %{model} \u003Cb\u003E%{from}\u0026nbsp;-\u0026nbsp;%{to}\u003C/b\u003E of \u003Cb\u003E%{count}\u003C/b\u003E in total"}}},"en-us":{"sidebars":{"recent_news":{"title":"Latest News"},"contests":{"running_contests":"Running Contests","running_virtual_contests":"Running Virtual Contests","scheduled_contests":"Upcoming Contests","scheduled_virtual_contests":"Upcoming Virtual Contests","current_item":"\u003Ca href='%{link}'\u003E%{title}\u003C/a\u003E ends at \u003Cspan class='display_time'\u003E%{end_time}\u003C/span\u003E","future_item":"\u003Ca href='%{link}'\u003E%{title}\u003C/a\u003E at \u003Cspan class='display_time'\u003E%{start_time}\u003C/span\u003E"},"vjudge_status":{"title":"VJudge Status","desc":"By checking remote status page every 10 minutes.","oj":"OJ","status":"Status","check_text":"Last Check: %{time}, %{status}"}},"problem":{"btns":{"all":"All","unsolved":"Unsolved","local_stat":"Local Stat","remote_stat":"Remote Stat","remote_user_stat":"Remote User Stat","submit":"Submit","status":"Status","stat":"Statistics","discuss":"Discuss","edit":"Edit"},"headers":{"flag":"Flag","pid":"ID","title":"Title","source":"Source","ac":"AC","all":"All","user_ac":"AC(U)","user_all":"All(U)","oj":"OJ","vid":"VID"},"show":{"time_limit":"Time Limit: %{time} ms","case_time_limit":"Case Time Limit: %{time} ms","memory_limit":"Memory Limit: %{memory} KB","virtual_info":"This problem will be judged on \u003Cspan class='label label-info'\u003E%{oj}\u003C/span\u003E. Original ID: \u003Ca href='%{url}' target='_blank'\u003E%{id}\u003C/a\u003E","language_info":"64-bit integer IO format: \u003Cspan class='label label-primary'\u003E%{io}\u003C/span\u003E \u0026nbsp;\u0026nbsp;\u0026nbsp;\u0026nbsp; Java class name: \u003Cspan class='label label-primary'\u003E%{class}\u003C/span\u003E","spj":"Special Judge","hidden":"This problem is hidden.","input":"Input","output":"Output","sample_input":"Sample Input","sample_output":"Sample Output","hint":"Hint","source":"Source","author":"Author","tags":"Tags","toggle":"Toggle"}},"home":{"default_title":"BNU Online Judge","footer_note":"Distributed under GPLv3. | \u003Ca href='https://github.com/51isoft/bnuoj' target='_blank'\u003EProject Homepage\u003C/a\u003E | Developer: \u003Ca href='mailto:yichaonet#gmail.com'\u003E51isoft\u003C/a\u003E."},"contest":{"btns":{"arrange_vcontest":"Arrange VContest","all":"All","standard":"Standard","virtual":"Virtual","icpc":"ICPC","cf":"CF","replay":"Replay","non_replay":"Non-Replay","public":"Public","password":"Password","private":"Private"},"headers":{"cid":"ID","title":"Title","start_time":"Start Time","end_time":"End Time","status":"Status","access":"Access","manager":"Manager","private":"Private","type":"Type"}},"navbar":{"toggle_navigation":"Toggle Navigation","brand_name":"BNUOJ","problem":{"main":"Problem","local_problems":"Local Problems","all_problems":"All Problems","problem_category":"Problem Category"},"status":"Status","contest":{"main":"Contest","standard_contests":"Standard Contests","icpc_contests":"Contests (ICPC format)","cf_contests":"Contests (CF format)","replay_contests":"Replay Contests","virtual_contests":"Virtual Contests"},"more":"More","ranklist":"Ranklist","discuss":"Discuss","news":"News","our_team":"Our Team","recent_contests":"Recent Contests","login":"Login","register":"Register","logout":"Logout","personal":{"show_my_info":"Show My Information","modify_my_info":"Modify My Information","admin":"Administration"}}}};