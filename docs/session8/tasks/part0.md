# Part 0 — Project Import

**Objective:** Download and import the Session 8 GNS3 project, then confirm that the lab topology has loaded correctly before beginning fault investigation.

---

## Task 0.1 — Download and Extract the Project

1. Download the `session8-capstone.zip` file provided by your instructor.
2. Extract the zip to a location of your choice — for example, `C:\GNS3\projects\session8-capstone\`.
3. Do not modify any files inside the extracted folder.

---

## Task 0.2 — Import into GNS3

1. Open GNS3.
2. From the menu, select **File > Open project**.
3. Navigate to the extracted folder and open `session8-capstone.gns3`.
4. GNS3 will load the project. If prompted about missing IOS images, confirm that your Cisco 3725 image is installed and named correctly (as configured in your GNS3 preferences from Session 1).

---

## Task 0.3 — Start All Devices

1. In the GNS3 toolbar, click **Start all nodes** (the green play button).
2. Wait approximately 60–90 seconds for all three routers to complete their boot sequence.
3. Confirm that all link indicators turn green.

---

## Task 0.4 — Baseline Check

Console into each router and confirm it responds. You do not need to verify full connectivity — faults are present and some checks will fail. Confirm only that the devices are up and accessible.

```
show version
show ip interface brief
```

If any router does not respond or shows no interfaces, stop and check that GNS3 started all nodes successfully before continuing.

---

> [!NOTE]
> The project arrives with three faults pre-injected. Some pings and connectivity checks will fail — that is expected. Parts 1 through 3 each describe a reported symptom. Your job is to find and fix the root cause of each one.
