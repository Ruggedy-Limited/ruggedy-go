Feature: As an administrator or user with the correct access control
  I want to edit, delete and suppress assets
  I want assets to have a relationship between vulnerabilities, scanners and exploit data
  I want to import assets from various sources, including nmap, Nexpose, Nessus, etc.
  I want to be able to add custom "tags" to assets for reporting and grouping.

  Assets:
  * An asset is one logical entry that represents a server/application/service, etc.
  * An asset will have one or two primary identifiers, for example IP Address or / and DNS name.
  * Assets are stored and managed under Workspaces
  * Assets should also be available in the "master assets" view - A view that contains a list of all assets under an account.

  Background:
    Given the following existing Users:
    | id | name           | email                        | password                                                     | remember_token | photo_url    | uses_two_factor_auth | authy_id | country_code | phone       | two_factor_reset_code | current_team_id | stripe_id | current_billing_plan | card_brand | card_last_four | card_country | billing_address | billing_address_line_2 | billing_city | billing_state | billing_zip | billing_country | vat_id | extra_billing_information | trial_ends_at       | last_read_announcements_at | created_at          | updated_at          |
    | 1  | John Smith     | johnsmith@dispostable.com    | $2y$10$IPgIlPVo/NW6fQMx0gJUyesYjV1N4LwC1fH2rj94s0gq.xDjMisNm | NULL           | NULL         | 0                    | NULL     | ZAR          | 0716852996  | NULL                  | 2               | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-19 14:39:01 | 2016-05-09 14:39:01        | 2016-05-09 14:39:01 | 2016-05-09 14:39:02 |
    | 2  | Greg Symons    | gregsymons@dispostable.com   | $2y$10$0WLCM1EUuJce.zSlS1N4h.XRn7u8uDbyxslTkFOI0ka0fxSIXmjhC | NULL           | /myphoto.jpg | 0                    | NULL     | NZ           | 06134582354 | NULL                  | 2               | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-20 11:51:29 | 2016-05-10 11:51:43        | 2016-05-10 11:51:29 | 2016-05-10 11:51:43 |
    | 3  | Another Person | another@dispostable.com      | $2y$10$0WLCM1EUuJce.zSlS1N4h.XRn7u8uDbyxslTkFOI0ka0fxSIXmjhC | NULL           | /aphoto.jpg  | 0                    | NULL     | AUS          | 08134582354 | NULL                  | 3               | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-20 11:51:29 | 2016-05-10 11:51:43        | 2016-05-10 11:51:29 | 2016-05-10 11:51:43 |
    | 4  | Tom Bombadill  | tombombadill@dispostable.com | $2y$10$0WLCM1EUuJce.zSlS1N4h.XRn7u8uDbyxslTkFOI0ka0fxSIXmjhC | NULL           | /aphoto.jpg  | 0                    | NULL     | USA          | 09134582354 | NULL                  |                 | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-20 11:51:29 | 2016-05-10 11:51:43        | 2016-06-01 11:51:29 | 2016-06-01 11:51:43 |
    | 5  | Bilbo Baggins  | bilbobaggins@dispostable.com | $2y$10$0WLCM1EUuJce.zSlS1N4h.XRn7u8uDbyxslTkFOI0ka0fxSIXmjhC | NULL           | /aphoto.jpg  | 0                    | NULL     | USA          | 09134582354 | NULL                  |                 | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-20 11:51:29 | 2016-05-10 11:51:43        | 2016-06-01 11:51:29 | 2016-06-01 11:51:43 |
    | 6  | Frodo Baggins  | frodobaggins@dispostable.com | $2y$10$0WLCM1EUuJce.zSlS1N4h.XRn7u8uDbyxslTkFOI0ka0fxSIXmjhC | NULL           | /aphoto.jpg  | 0                    | NULL     | USA          | 09134582354 | NULL                  |                 | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-20 11:51:29 | 2016-05-10 11:51:43        | 2016-06-01 11:51:29 | 2016-06-01 11:51:43 |
    | 7  | Samwise Gangee | samgangee@dispostable.com    | $2y$10$0WLCM1EUuJce.zSlS1N4h.XRn7u8uDbyxslTkFOI0ka0fxSIXmjhC | NULL           | /aphoto.jpg  | 0                    | NULL     | USA          | 09134582354 | NULL                  |                 | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-20 11:51:29 | 2016-05-10 11:51:43        | 2016-06-01 11:51:29 | 2016-06-01 11:51:43 |
    | 8  | Aragorn        | aragorn@dispostable.com      | $2y$10$0WLCM1EUuJce.zSlS1N4h.XRn7u8uDbyxslTkFOI0ka0fxSIXmjhC | NULL           | /aphoto.jpg  | 0                    | NULL     | USA          | 09134582354 | NULL                  |                 | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-20 11:51:29 | 2016-05-10 11:51:43        | 2016-06-01 11:51:29 | 2016-06-01 11:51:43 |
    | 9  | Gimli          | gimli@dispostable.com        | $2y$10$0WLCM1EUuJce.zSlS1N4h.XRn7u8uDbyxslTkFOI0ka0fxSIXmjhC | NULL           | /aphoto.jpg  | 0                    | NULL     | USA          | 09134582354 | NULL                  |                 | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-20 11:51:29 | 2016-05-10 11:51:43        | 2016-06-01 11:51:29 | 2016-06-01 11:51:43 |
    And the following existing Teams:
    | id | owner_id | name        | photo_url | stripe_id | current_billing_plan | card_brand | card_last_four | card_country | billing_address | billing_address_line_2 | billing_city | billing_state | billing_zip | billing_country | vat_id | extra_billing_information | trial_ends_at       | created_at          | updated_at          |
    | 1  | 1        | John's Team | NULL      | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-09 14:39:01 | 2016-05-09 14:39:01 | 2016-05-09 14:39:01 |
    | 2  | 2        | Greg's Team | NULL      | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-09 14:39:01 | 2016-06-01 14:39:01 | 2016-06-01 14:39:01 |
    | 3  | 4        | Tom's Team  | NULL      | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-09 14:39:01 | 2016-06-01 14:39:01 | 2016-06-01 14:39:01 |
    And the following Users in Team 1:
    | id | role   |
    | 1  | owner  |
    | 2  | member |
    And the following Users in Team 2:
    | id | role   |
    | 2  | owner  |
    | 1  | member |
    And the following existing Workspaces:
    | id | name                | user_id  | created_at          | updated_at          |
    | 1  | John's Workspace    | 1        | 2016-05-13 11:06:00 | 2016-05-13 11:06:00 |
    | 2  | Someone's Workspace | 2        | 2016-05-13 10:06:00 | 2016-05-13 10:06:00 |
    | 3  | Another Workspace   | 3        | 2016-05-13 09:06:00 | 2016-05-13 09:06:00 |
    | 4  | Shared Workspace    | 1        | 2016-05-13 09:06:00 | 2016-05-13 09:06:00 |
    And the following existing Assets:
    | id | name                      | cpe                                                                 | vendor    | ip_address_v4 | ip_address_v6                           | hostname                  | mac_address       | os_version | netbios | file_id | user_id | created_at          | updated_at          |
    | 1  | homenetwork.home.co.za    | cpe:/o:ubuntu:ubuntu_linux:9.10                                     | Ubuntu    | 192.168.0.10  | FE80:0000:0000:0000:0202:B3FF:FE1E:8329 | homenetwork.home.co.za    | D0:E1:40:8C:63:6A | 9.10       | NULL    | 1       | 1       | 2016-06-20 09:00:00 | 2016-06-20 09:00:00 |
    | 2  | Windows Server 2003       | cpe:2.3:o:microsoft:windows_2003_server:*:gold:enterprise:*:*:*:*:* | Microsoft | 192.168.0.12  | fd03:10d3:bb1c::/48                     | NULL                      | NULL              | 5.2.3790   | NULL    | 1       | 1       | 2016-06-20 09:02:23 | 2016-06-20 09:02:23 |
    | 3  | 192.168.0.24              | NULL                                                                | NULL      | 192.168.0.24  | NULL                                    | NULL                      | NULL              | NULL       | NULL    | 1       | 1       | 2016-06-20 09:05:31 | 2016-06-20 09:05:31 |
    | 4  | webapp.test               | cpe:2.3:a:nginx:nginx:1.9.8:*:*:*:*:*:*:*                           | nginx     | 192.168.0.38  | NULL                                    | webapp.test               | NULL              | NULL       | NULL    | 1       | 1       | 2016-06-20 09:05:38 | 2016-06-20 09:05:38 |
    | 5  | ubuntu2.homenetwork.co.za | cpe:/o:ubuntu:ubuntu_linux:12.10                                    | Ubuntu    | NULL          | NULL                                    | ubuntu2.homenetwork.co.za | NULL              | 12.10      | NULL    | 1       | 1       | 2016-06-20 09:06:00 | 2016-06-20 09:06:00 |
    | 6  | fde3:970e:b33d::/48       | cpe:2.3:o:microsoft:windows_server_2008:*:*:x64:*:*:*:*:*           | Microsoft | NULL          | fde3:970e:b33d::/48                     | NULL                      | NULL              | 6.0.6001   | NULL    | 1       | 1       | 2016-06-20 09:07:23 | 2016-06-20 09:07:23 |
    | 7  | 192.168.1.24              | NULL                                                                | NULL      | 192.168.1.24  | NULL                                    | NULL                      | NULL              | NULL       | NULL    | 2       | 2       | 2016-06-20 09:08:31 | 2016-06-20 09:08:31 |
    | 8  | local.mysite.com          | cpe:2.3:a:nginx:nginx:1.1.8:*:*:*:*:*:*:*                           | nginx     | 192.168.0.38  | NULL                                    | local.mysite.com          | NULL              | NULL       | NULL    | 3       | 3       | 2016-06-20 09:09:38 | 2016-06-20 09:09:38 |
    And the following existing Files:
    | id | path                                                                                 | format | size    | user_id | workspace_id | scanner_app_id | processed | deleted | created_at          | updated_at          |
    | 1  | /usr/local/var/www/ruggedy/storage/scans/xml/nmap/1/nmap-adv-multiple-node-dns.xml   | xml    | 18646   | 1       | 1            | 1              | 1         | 0       | 2016-10-10 06:51:18 | 2017-01-11 15:31:06 |
    | 2  | /usr/local/var/www/ruggedy/storage/scans/xml/burp/1/burp-multiple-auth-dns+ip.xml    | xml    | 4660178 | 1       | 2            | 2              | 1         | 0       | 2016-10-10 06:51:35 | 2017-01-11 15:31:06 |
    | 3  | /usr/local/var/www/ruggedy/storage/scans/xml/nexpose/1/full-multiple-dns.xml         | xml    | 3662061 | 1       | 1            | 3              | 1         | 0       | 2016-10-10 06:51:53 | 2017-01-11 15:31:06 |
    | 4  | /usr/local/var/www/ruggedy/storage/scans/xml/netsparker/1/single-dns.xml             | xml    | 568818  | 1       | 1            | 4              | 1         | 0       | 2016-10-17 19:25:33 | 2017-01-11 15:31:06 |
    | 5  | /usr/local/var/www/ruggedy/storage/scans/xml/nessus/1/full-multiple-dns.nessus       | xml    | 1841174 | 1       | 1            | 5              | 1         | 0       | 2016-10-24 07:26:59 | 2017-01-11 15:31:06 |
    | 8  | /usr/local/var/www/ruggedy/storage/scans/xml/nessus/1/full-audit-multiple-dns.nessus | xml    | 2664096 | 1       | 1            | 5              | 1         | 0       | 2016-11-07 07:22:00 | 2017-01-11 15:31:06 |
    | 9  | /usr/local/var/www/ruggedy/storage/scans/xml/burp/1/burp-single-auth-dns             | xml    | 3564946 | 1       | 1            | 2              | 1         | 0       | 2017-01-11 12:06:30 | 2017-01-11 15:31:06 |
    | 10 | /usr/local/var/www/ruggedy/storage/scans/xml/burp/1/burp-single-auth-ip              | xml    | 1166017 | 1       | 1            | 2              | 1         | 0       | 2017-01-11 12:06:48 | 2017-01-11 15:31:06 |
    | 11 | /usr/local/var/www/ruggedy/storage/scans/xml/nessus/1/full-audit-single-dns.nessus   | xml    | 1759340 | 1       | 1            | 5              | 1         | 0       | 2017-01-11 12:07:08 | 2017-01-11 15:31:06 |
    | 12 | /usr/local/var/www/ruggedy/storage/scans/xml/nessus/1/full-audit-multiple-ip.nessus  | xml    | 2657649 | 1       | 1            | 5              | 1         | 0       | 2017-01-11 12:07:25 | 2017-01-11 15:31:06 |
    | 13 | /usr/local/var/www/ruggedy/storage/scans/xml/nessus/1/full-audit-single-ip.nessus    | xml    | 2069530 | 1       | 1            | 5              | 1         | 0       | 2017-01-11 12:07:43 | 2017-01-11 15:31:06 |
    | 14 | /usr/local/var/www/ruggedy/storage/scans/xml/nessus/1/full-single-dns.nessus         | xml    | 1570556 | 1       | 1            | 5              | 1         | 0       | 2017-01-11 12:07:59 | 2017-01-11 15:31:06 |
    | 15 | /usr/local/var/www/ruggedy/storage/scans/xml/nessus/1/full-multiple-ip.nessus        | xml    | 1832322 | 1       | 1            | 5              | 1         | 0       | 2017-01-11 12:08:07 | 2017-01-11 15:31:06 |
    | 16 | /usr/local/var/www/ruggedy/storage/scans/xml/nessus/1/full-single-ip.nessus          | xml    | 1564661 | 1       | 1            | 5              | 1         | 0       | 2017-01-11 12:08:16 | 2017-01-11 15:31:06 |
    | 17 | /usr/local/var/www/ruggedy/storage/scans/xml/nmap/1/nmap-adv-1-node-dns              | xml    | 8428    | 1       | 1            | 1              | 1         | 0       | 2017-01-11 12:08:47 | 2017-01-11 15:31:06 |
    | 18 | /usr/local/var/www/ruggedy/storage/scans/xml/nmap/1/nmap-basic-multiple-node-dns     | xml    | 8703    | 1       | 1            | 1              | 1         | 0       | 2017-01-11 12:08:59 | 2017-01-11 15:31:06 |
    | 19 | /usr/local/var/www/ruggedy/storage/scans/xml/nmap/1/nmap-basic-1-node-dns            | xml    | 6750    | 1       | 1            | 1              | 1         | 0       | 2017-01-11 12:09:12 | 2017-01-11 15:31:06 |
    | 20 | /usr/local/var/www/ruggedy/storage/scans/xml/nmap/1/nmap-adv-multiple-node-ip        | xml    | 18431   | 1       | 1            | 1              | 1         | 0       | 2017-01-11 12:09:21 | 2017-01-11 15:31:06 |
    | 21 | /usr/local/var/www/ruggedy/storage/scans/xml/nmap/1/nmap-adv-1-node-ip               | xml    | 8369    | 1       | 1            | 1              | 1         | 0       | 2017-01-11 12:09:44 | 2017-01-11 15:31:06 |
    | 22 | /usr/local/var/www/ruggedy/storage/scans/xml/nmap/1/nmap-basic-multiple-node-ip      | xml    | 8486    | 1       | 1            | 1              | 1         | 0       | 2017-01-11 12:09:53 | 2017-01-11 15:31:06 |
    | 23 | /usr/local/var/www/ruggedy/storage/scans/xml/nmap/1/nmap-basic-1-node-ip             | xml    | 6692    | 1       | 1            | 1              | 1         | 0       | 2017-01-11 12:10:06 | 2017-01-11 15:31:06 |
    | 24 | /usr/local/var/www/ruggedy/storage/scans/xml/nexpose/1/full-single-dns.xml           | xml    | 2909307 | 1       | 1            | 3              | 1         | 0       | 2017-01-11 12:10:16 | 2017-01-11 15:31:06 |
    | 25 | /usr/local/var/www/ruggedy/storage/scans/xml/nexpose/1/full-multiple-ip.xml          | xml    | 3645992 | 1       | 1            | 3              | 1         | 0       | 2017-01-11 12:10:29 | 2017-01-11 15:31:06 |
    | 26 | /usr/local/var/www/ruggedy/storage/scans/xml/nexpose/1/full-single-ip.xml            | xml    | 2907981 | 1       | 1            | 3              | 1         | 0       | 2017-01-11 12:10:40 | 2017-01-11 15:31:06 |
    And the following existing Components:
    | id | name            | class_name | created_at          | updated_at          |
    | 1  | User Account    | User       | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 2  | Team            | Team       | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 3  | Workspace       | Workspace  | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 4  | Asset           | Asset      | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 5  | Scanner App     | ScannerApp | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 6  | Event           | Event      | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 7  | Rules           | Rule       | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    And the following existing ScannerApps:
    | id | name       | description                      | created_at          | updated_at          |
    | 1  | nmap       | NMAP Port Scanner Utility        | 2016-07-28 23:17:04 | 2016-07-28 23:17:04 |
    | 2  | burp       | Burp Vulnerability Scanner       | 2016-07-28 23:17:04 | 2016-07-28 23:17:04 |
    | 3  | netsparker | Netsparker Vulnerability Scanner | 2016-07-28 23:17:04 | 2016-07-28 23:17:04 |
    | 4  | nexpose    | Nexpose Vulnerability Scanner    | 2016-07-28 23:17:04 | 2016-07-28 23:17:04 |
    | 5  | nessus     | Nessus Vulnerability Scanner     | 2016-07-28 23:17:04 | 2016-07-28 23:17:04 |
    And the following existing ComponentPermissions:
    | id | component_id | instance_id | permission | user_id | team_id | granted_by | created_at          | updated_at          |
    | 1  | 1            | 2           | rw         | 1       | NULL    | 2          | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 2  | 1            | 1           | r          | 6       | NULL    | 1          | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 3  | 2            | 1           | rw         | 7       | NULL    | 1          | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 4  | 2            | 1           | r          | 8       | NULL    | 1          | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 5  | 3            | 4           | rw         | 9       | NULL    | 1          | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 6  | 3            | 4           | r          | 3       | NULL    | 1          | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 7  | 3            | 4           | rw         | NULL    | 1       | 1          | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    | 8  | 3            | 4           | r          | NULL    | 2       | 1          | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    And a valid API key "OaLLlZl4XB9wgmSGg7uai1nvtTiDsLpSBCfFoLKv18GCDdiIxxPLslKZmcPN"

  ##
  # Importing scanner results
  ##
  Scenario: Import an NMAP scan into one of my Workspaces
    Given that I want to make a new "Asset"
    And that its "name" is "Web Server"
    And that its "file" is "nmap-adv-multiple-node-dns.xml"
    When I request "/api/asset/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the response has a "filename" property
    And the type of the "filename" property is string
    And the "filename" property equals "nmap-adv-multiple-node-dns.xml"
    And the response has a "format" property
    And the type of the "format" property is string
    And the "format" property equals "xml"
    And the response has a "size" property
    And the type of the "size" property is integer
    And the response has a "isProcessed" property
    And the type of the "isProcessed" property is boolean
    And the "isProcessed" property equals "false"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "false"
    And the response has a "ownerId" property
    And the type of the "ownerId" property is integer
    And the "ownerId" property equals "1"
    And the response has a "workspaceId" property
    And the type of the "workspaceId" property is integer
    And the "workspaceId" property equals "1"

  Scenario: Import an NMAP scan into someone else's Workspace where I have write access
    Given that I want to make a new "Asset"
    And that its "name" is "Web Server"
    And that its "file" is "nmap-adv-multiple-node-dns.xml"
    When I request "/api/asset/4"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the response has a "filename" property
    And the type of the "filename" property is string
    And the "filename" property equals "nmap-adv-multiple-node-dns.xml"
    And the response has a "format" property
    And the type of the "format" property is string
    And the "format" property equals "xml"
    And the response has a "size" property
    And the type of the "size" property is integer
    And the response has a "isProcessed" property
    And the type of the "isProcessed" property is boolean
    And the "isProcessed" property equals "false"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "false"
    And the response has a "ownerId" property
    And the type of the "ownerId" property is integer
    And the "ownerId" property equals "1"
    And the response has a "workspaceId" property
    And the type of the "workspaceId" property is integer
    And the "workspaceId" property equals "4"

  Scenario: Import a Burp scan into one of my Workspaces
    Given that I want to make a new "Asset"
    And that its "name" is "Web Server"
    And that its "file" is "burp/burp-multiple-auth-dns+ip.xml"
    When I request "/api/asset/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the response has a "filename" property
    And the type of the "filename" property is string
    And the "filename" property equals "burp-multiple-auth-dns+ip.xml"
    And the response has a "format" property
    And the type of the "format" property is string
    And the "format" property equals "xml"
    And the response has a "size" property
    And the type of the "size" property is integer
    And the response has a "isProcessed" property
    And the type of the "isProcessed" property is boolean
    And the "isProcessed" property equals "false"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "false"
    And the response has a "ownerId" property
    And the type of the "ownerId" property is integer
    And the "ownerId" property equals "1"
    And the response has a "workspaceId" property
    And the type of the "workspaceId" property is integer
    And the "workspaceId" property equals "1"

  Scenario: Import a Burp scan into someone else's Workspace where I have write access
    Given that I want to make a new "Asset"
    And that its "name" is "Web Server"
    And that its "file" is "burp/burp-multiple-auth-dns+ip.xml"
    When I request "/api/asset/4"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the response has a "filename" property
    And the type of the "filename" property is string
    And the "filename" property equals "burp-multiple-auth-dns+ip.xml"
    And the response has a "format" property
    And the type of the "format" property is string
    And the "format" property equals "xml"
    And the response has a "size" property
    And the type of the "size" property is integer
    And the response has a "isProcessed" property
    And the type of the "isProcessed" property is boolean
    And the "isProcessed" property equals "false"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "false"
    And the response has a "ownerId" property
    And the type of the "ownerId" property is integer
    And the "ownerId" property equals "1"
    And the response has a "workspaceId" property
    And the type of the "workspaceId" property is integer
    And the "workspaceId" property equals "4"

  Scenario: Import a Netsparker scan into one of my Workspaces
    Given that I want to make a new "Asset"
    And that its "name" is "Web Server"
    And that its "file" is "netsparker/single-dns.xml"
    When I request "/api/asset/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the response has a "filename" property
    And the type of the "filename" property is string
    And the "filename" property equals "single-dns.xml"
    And the response has a "format" property
    And the type of the "format" property is string
    And the "format" property equals "xml"
    And the response has a "size" property
    And the type of the "size" property is integer
    And the response has a "isProcessed" property
    And the type of the "isProcessed" property is boolean
    And the "isProcessed" property equals "false"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "false"
    And the response has a "ownerId" property
    And the type of the "ownerId" property is integer
    And the "ownerId" property equals "1"
    And the response has a "workspaceId" property
    And the type of the "workspaceId" property is integer
    And the "workspaceId" property equals "1"

  Scenario: Import a Netsparker scan into someone else's Workspace where I have write access
    Given that I want to make a new "Asset"
    And that its "name" is "Web Server"
    And that its "file" is "netsparker/single-dns.xml"
    When I request "/api/asset/4"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the response has a "filename" property
    And the type of the "filename" property is string
    And the "filename" property equals "single-dns.xml"
    And the response has a "format" property
    And the type of the "format" property is string
    And the "format" property equals "xml"
    And the response has a "size" property
    And the type of the "size" property is integer
    And the response has a "isProcessed" property
    And the type of the "isProcessed" property is boolean
    And the "isProcessed" property equals "false"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "false"
    And the response has a "ownerId" property
    And the type of the "ownerId" property is integer
    And the "ownerId" property equals "1"
    And the response has a "workspaceId" property
    And the type of the "workspaceId" property is integer
    And the "workspaceId" property equals "4"

  Scenario: Import a Nexpose scan into one of my Workspaces
    Given that I want to make a new "Asset"
    And that its "name" is "Web Server"
    And that its "file" is "nexpose/full-multiple-dns.xml"
    When I request "/api/asset/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the response has a "filename" property
    And the type of the "filename" property is string
    And the "filename" property equals "full-multiple-dns.xml"
    And the response has a "format" property
    And the type of the "format" property is string
    And the "format" property equals "xml"
    And the response has a "size" property
    And the type of the "size" property is integer
    And the response has a "isProcessed" property
    And the type of the "isProcessed" property is boolean
    And the "isProcessed" property equals "false"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "false"
    And the response has a "ownerId" property
    And the type of the "ownerId" property is integer
    And the "ownerId" property equals "1"
    And the response has a "workspaceId" property
    And the type of the "workspaceId" property is integer
    And the "workspaceId" property equals "1"

  Scenario: Import a Nexpose scan into someone else's Workspace where I have write access
    Given that I want to make a new "Asset"
    And that its "name" is "Web Server"
    And that its "file" is "nexpose/full-multiple-dns.xml"
    When I request "/api/asset/4"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the response has a "filename" property
    And the type of the "filename" property is string
    And the "filename" property equals "full-multiple-dns.xml"
    And the response has a "format" property
    And the type of the "format" property is string
    And the "format" property equals "xml"
    And the response has a "size" property
    And the type of the "size" property is integer
    And the response has a "isProcessed" property
    And the type of the "isProcessed" property is boolean
    And the "isProcessed" property equals "false"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "false"
    And the response has a "ownerId" property
    And the type of the "ownerId" property is integer
    And the "ownerId" property equals "1"
    And the response has a "workspaceId" property
    And the type of the "workspaceId" property is integer
    And the "workspaceId" property equals "4"

  Scenario: Import a Nessus scan into one of my Workspaces
    Given that I want to make a new "Asset"
    And that its "name" is "Web Server"
    And that its "file" is "nessus/full-audit-multiple-dns.nessus"
    When I request "/api/asset/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the response has a "filename" property
    And the type of the "filename" property is string
    And the "filename" property equals "full-audit-multiple-dns.nessus"
    And the response has a "format" property
    And the type of the "format" property is string
    And the "format" property equals "xml"
    And the response has a "size" property
    And the type of the "size" property is integer
    And the response has a "isProcessed" property
    And the type of the "isProcessed" property is boolean
    And the "isProcessed" property equals "false"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "false"
    And the response has a "ownerId" property
    And the type of the "ownerId" property is integer
    And the "ownerId" property equals "1"
    And the response has a "workspaceId" property
    And the type of the "workspaceId" property is integer
    And the "workspaceId" property equals "1"

  Scenario: Import a Nessus scan into someone else's Workspace where I have write access
    Given that I want to make a new "Asset"
    And that its "name" is "Web Server"
    And that its "file" is "nessus/full-audit-multiple-dns.nessus"
    When I request "/api/asset/4"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the response has a "filename" property
    And the type of the "filename" property is string
    And the "filename" property equals "full-audit-multiple-dns.nessus"
    And the response has a "format" property
    And the type of the "format" property is string
    And the "format" property equals "xml"
    And the response has a "size" property
    And the type of the "size" property is integer
    And the response has a "isProcessed" property
    And the type of the "isProcessed" property is boolean
    And the "isProcessed" property equals "false"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "false"
    And the response has a "ownerId" property
    And the type of the "ownerId" property is integer
    And the "ownerId" property equals "1"
    And the response has a "workspaceId" property
    And the type of the "workspaceId" property is integer
    And the "workspaceId" property equals "4"

  ##
  # Edit and Suppress Assets
  ##
  Scenario: Edit the name of one of my Assets
    Given that I want to update my "Asset"
    And that I want to change it's "name" to "Name Changed Asset"
    When I request "/api/asset/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the "id" property equals "1"
    And the response has a "name" property
    And the type of the "name" property is string
    And the "name" property equals "Name Changed Asset"

  Scenario: Edit the name of someone else's Asset where I have write permission
    Given that I want to update my "Asset"
    And that I want to change it's "name" to "Name Changed Asset"
    When I request "/api/asset/7"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the "id" property equals "7"
    And the response has a "name" property
    And the type of the "name" property is string
    And the "name" property equals "Name Changed Asset"

  Scenario: Attempt to edit the name of someone else's Asset where I don't have write permission
    Given that I want to update my "Asset"
    And that I want to change it's "name" to "Name Changed Asset"
    When I request "/api/asset/8"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, you don't have permission to make changes to that Asset."

  Scenario: I attempt to edit the name of a non-existent Asset
    Given that I want to update my "Asset"
    And that I want to change it's "name" to "Name Changed Asset"
    When I request "/api/asset/100"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, that Asset does not exist."

  Scenario: Suppress one of my Assets
    Given that I want to update my "Asset"
    And that I want to change it's "suppressed" to "true"
    When I request "/api/asset/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the "id" property equals "1"
    And the response has a "isSuppressed" property
    And the type of the "isSuppressed" property is boolean
    And the "isSuppressed" property equals "true"

  Scenario: Suppress someone else's Asset where I have write permission
    Given that I want to update my "Asset"
    And that I want to change it's "suppressed" to "true"
    When I request "/api/asset/7"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the "id" property equals "7"
    And the response has a "isSuppressed" property
    And the type of the "isSuppressed" property is boolean
    And the "isSuppressed" property equals "true"

  Scenario: Attempt to suppress someone else's Asset where I don't have write permission
    Given that I want to update my "Asset"
    And that I want to change it's "suppressed" to "true"
    When I request "/api/asset/8"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, you don't have permission to make changes to that Asset."

  Scenario: I attempt to edit the name of a non-existent Asset
    Given that I want to update my "Asset"
    And that I want to change it's "suppressed" to "true"
    When I request "/api/asset/100"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, that Asset does not exist."

  ##
  # Add a single tag and multiple tags to an Asset
  ##

  ##
  # Delete Assets
  ##
  Scenario: Delete one of my Assets
    Given that I want to delete a "Asset"
    When I request "/api/asset/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the "id" property equals "1"
    And the response has a "name" property
    And the type of the "name" property is string
    And the "name" property equals "homenetwork.home.co.za"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "false"

  Scenario: Delete and confirm deletion of one of my Assets
    Given that I want to delete a "Asset"
    When I request "/api/asset/1/confirm"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the "id" property equals "1"
    And the response has a "name" property
    And the type of the "name" property is string
    And the "name" property equals "homenetwork.home.co.za"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "true"

  Scenario: Delete someone else's Asset where I have write permission
    Given that I want to delete a "Asset"
    When I request "/api/asset/7"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the "id" property equals "7"
    And the response has a "name" property
    And the type of the "name" property is string
    And the "name" property equals "192.168.1.24"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "false"

  Scenario: Delete and confirm deletion of someone else's Asset where I have write permission
    Given that I want to delete a "Asset"
    When I request "/api/asset/7/confirm"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "id" property
    And the type of the "id" property is integer
    And the "id" property equals "7"
    And the response has a "name" property
    And the type of the "name" property is string
    And the "name" property equals "192.168.1.24"
    And the response has a "isDeleted" property
    And the type of the "isDeleted" property is boolean
    And the "isDeleted" property equals "true"

  Scenario: Attempt to Delete an Asset where I don't have the write permission
    Given that I want to delete a "Asset"
    When I request "/api/asset/8"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, you don't have permission to delete that Asset."

  Scenario: Attempt to delete a non-existent Asset
    Given that I want to delete a "Asset"
    When I request "/api/asset/20"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, that Asset does not exist."

  ##
  # Suppress specific events for a specific Asset
  ## TBD


  ##
  # Get all the Assets from all of my Projects and Workspaces (Master Assets View)
  ##
  Scenario: Retrieve a list of all the Assets on my account
    Given that I want to get information about my "Assets"
    When I request "/api/assets"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the array response has the following items:
    | id | name                      | cpe                                                                 | os        | ipAddress     | ipAddressV6                             | hostname                  | macAddress        | osVersion  | fileId  |
    | 1  | homenetwork.home.co.za    | cpe:/o:ubuntu:ubuntu_linux:9.10                                     | Ubuntu    | 192.168.0.10  | FE80:0000:0000:0000:0202:B3FF:FE1E:8329 | homenetwork.home.co.za    | D0:E1:40:8C:63:6A | 9.10       | 1       |
    | 2  | Windows Server 2003       | cpe:2.3:o:microsoft:windows_2003_server:*:gold:enterprise:*:*:*:*:* | Microsoft | 192.168.0.12  | fd03:10d3:bb1c::/48                     | *                         | *                 | 5.2.3790   | 1       |
    | 3  | 192.168.0.24              | *                                                                   | *         | 192.168.0.24  | *                                       | *                         | *                 | *          | 1       |
    | 4  | webapp.test               | cpe:2.3:a:nginx:nginx:1.9.8:*:*:*:*:*:*:*                           | nginx     | 192.168.0.38  | *                                       | webapp.test               | *                 | *          | 1       |
    | 5  | ubuntu2.homenetwork.co.za | cpe:/o:ubuntu:ubuntu_linux:12.10                                    | Ubuntu    | *             | *                                       | ubuntu2.homenetwork.co.za | *                 | 12.10      | 1       |
    | 6  | fde3:970e:b33d::/48       | cpe:2.3:o:microsoft:windows_server_2008:*:*:x64:*:*:*:*:*           | Microsoft | *             | fde3:970e:b33d::/48                     | *                         | *                 | 6.0.6001   | 1       |

  ##
  # Get all Assets from a specific Workspace
  ##
  Scenario: Retrieve a list of Assets that are part of one of my Workspaces
    Given that I want to get information about my "Assets"
    When I request "/api/assets/workspace/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the array response has the following items:
      | id | name                      | cpe                                                                 | os        | ipAddress     | ipAddressV6                             | hostname                  | macAddress        | osVersion  | fileId  |
      | 1  | homenetwork.home.co.za    | cpe:/o:ubuntu:ubuntu_linux:9.10                                     | Ubuntu    | 192.168.0.10  | FE80:0000:0000:0000:0202:B3FF:FE1E:8329 | homenetwork.home.co.za    | D0:E1:40:8C:63:6A | 9.10       | 1       |
      | 2  | Windows Server 2003       | cpe:2.3:o:microsoft:windows_2003_server:*:gold:enterprise:*:*:*:*:* | Microsoft | 192.168.0.12  | fd03:10d3:bb1c::/48                     | *                         | *                 | 5.2.3790   | 1       |
      | 3  | 192.168.0.24              | *                                                                   | *         | 192.168.0.24  | *                                       | *                         | *                 | *          | 1       |
      | 4  | webapp.test               | cpe:2.3:a:nginx:nginx:1.9.8:*:*:*:*:*:*:*                           | nginx     | 192.168.0.38  | *                                       | webapp.test               | *                 | *          | 1       |
      | 5  | ubuntu2.homenetwork.co.za | cpe:/o:ubuntu:ubuntu_linux:12.10                                    | Ubuntu    | *             | *                                       | ubuntu2.homenetwork.co.za | *                 | 12.10      | 1       |
      | 6  | fde3:970e:b33d::/48       | cpe:2.3:o:microsoft:windows_server_2008:*:*:x64:*:*:*:*:*           | Microsoft | *             | fde3:970e:b33d::/48                     | *                         | *                 | 6.0.6001   | 1       |

  Scenario: Retrieve a list of Assets that are part of someone else's Workspace where I have at least read permission
    Given that I want to get information about my "Assets"
    When I request "/api/assets/workspace/2"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the array response has the following items:
      | id | name         | fileId |
      | 7  | 192.168.1.24 | 2      |

  Scenario: Attempt to retrieve a list of Assets that are part of someone else's Workspace where I don't have permission
    Given that I want to get information about my "Assets"
    When I request "/api/assets/workspace/3"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, you don't have permission to list those Assets."

  Scenario: Attempt to retrieve a list of Assets for an non-existent Workspace
    Given that I want to get information about my "Assets"
    When I request "/api/assets/workspace/100"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, that Workspace does not exist."

  ##
  # Get a list of scanners used on a particular Asset
  ##

  ##
  # Get all the Vulnerabilities related to an Asset
  ##

  ##
  # Get all the open ports related to an Asset
  ##