---
permalink: /
title: ""
excerpt: ""
author_profile: true
redirect_from: 
  - /about/
  - /about.html
---

{% if site.google_scholar_stats_use_cdn %}
{% assign gsDataBaseUrl = "https://cdn.jsdelivr.net/gh/" | append: site.repository | append: "@" %}
{% else %}
{% assign gsDataBaseUrl = "https://raw.githubusercontent.com/" | append: site.repository | append: "/" %}
{% endif %}
{% assign url = gsDataBaseUrl | append: "google-scholar-stats/gs_data_shieldsio.json" %}

<span class='anchor' id='about-me'></span>

我现工作于东北大学计算机科学与工程学院，智慧系统国际合作联合实验，任特聘助理教授。东北大学博士，师从王义教授、[关楠](https://www.cityu.edu.hk/stfprofile/nanguan.htm)教授。现已在国际顶级学术会议、期刊发表论文10余篇。
 <a href='https://scholar.google.com/citations?user=SCHOLAR_ID&user=djVfjSQAAAAJ'><img src="https://img.shields.io/endpoint?url={{ url | url_encode }}&logo=Google%20Scholar&labelColor=f6f6f6&color=9cf&style=flat&label=引用"></a>。

我的研究领域包括：
- 间歇计算系统 (Intermittent Systems)
- 实时嵌入式系统 (Real-time Embedded Systems)
- 机器人操作系统 (Robotic Operating System, ROS2)
- 边缘计算 (On-device AI)

<span class='anchor' id='-lwzl'></span>

# 📝 代表性论文
---
-	Light Flash Write for Efficient Firmware Update on Energy-harvesting IoT Devices. DATE2023. (CCF-B)
[[网页]]() [[预览]]() [[下载]]()
-	Adaptive Task-based Intermittent Computing System with Parallel State Backup. IEEE TCAD, 2022. (CCF-A)
[[网页]]() [[预览]]() [[下载]]()
-	Surviving Transient Power Failures with SRAM Data Retention. DATE2021. (CCF-B)
[[网页]]() [[预览]]() [[下载]]()
- LATICS: A low-overhead adaptive task-based intermittent computing system. IEEE TCAD, 2021. (CCF-A)
[[网页]]() [[预览]]() [[下载]]()
- EDF-VD scheduling of mixed-criticality systems with degraded quality guarantees. RTSS2016. (CCF-A)
[[网页]]() [[预览]]() [[下载]]()
- `Songran Liu`, Nan Guan, Dong Ji, Weichen Liu, Xue Liu, Wang Yi, Leaking your engine speed by spectrum analysis of real-Time scheduling sequences. *Journal of Systems Architecture*. 2019. (JCR:Q2; IF:4.838)  
[[网页]]() [[预览]]() [[下载]]()



# 📝 项目
---
### 间歇计算系统
- LATICS: A low-overhead adaptive task-based intermittent computing system.  
[[网页]]()

### 机器人操作系统
- neuROS
[[网页]]()

- ROS2
[[网页]]()


# 📝 教学
---
- [《8086汇编语言程序设计》](../Teaching/Assembly/Spring2022.md)

<span class='anchor' id='-ryjx'></span>

# 🏅 荣誉奖项
---
- *2022.11* 获得 CCF-B类会议DATE2023 Best Paper Candidate
