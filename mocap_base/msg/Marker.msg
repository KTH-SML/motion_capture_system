string id # Id of the tracker. Either its name if labeled or 'Unlabeled_{QTM_marker_id_number}'
bool labeled # Is the tracker manually labeled in QTM (can be part of 6DOF, AIM, ...).
bool tracked # Is the tracker currently seen by the cameras.
geometry_msgs/Point position # 3D position of the tracker, in the mocap frame
float64 residual # Residual error of the position