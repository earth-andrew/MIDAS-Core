%run jobs on these 3 clusters

% cluster1 = parcluster('MIDAS Benchmarks')
% cluster2 = parcluster('MIDAS Benchmarks 2')
cluster3 = parcluster('MIDAS Benchmarks 3')
% job1 = createCommunicatingJob(cluster1,'Type','Pool');
% job2 = createCommunicatingJob(cluster2,'Type','Pool');
job3 = createCommunicatingJob(cluster3,'Type','Pool');
% task1 = createTask(job1, @runMIDAS_Benchmarks_FullSensitivity, 0, {}, 'CaptureDiary', true);
% task2 = createTask(job2, @runMIDAS_Benchmarks_FullSensitivity, 0, {}, 'CaptureDiary', true);
task3 = createTask(job3, @runMIDAS_Benchmarks_FullSensitivity, 0, {}, 'CaptureDiary', true);
% submit(job1)
% submit(job2)
submit(job3)