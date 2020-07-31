using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
public class GetGUID : EditorWindow
{
    Object target;
    [MenuItem("Window/GUID Manager")]
        static void Init() {
            GetGUID window = (GetGUID)EditorWindow.GetWindow(typeof(GetGUID), false, "GUID  Manager");
            window.Show();
        }
        void OnGUI(){
            
            string guid;
            long id;
            target = EditorGUILayout.ObjectField(obj: target, objType: typeof(Object), allowSceneObjects: false, label: "Asset");
            if (!target)
                return;
            AssetDatabase.TryGetGUIDAndLocalFileIdentifier(target,out guid, out id);
            EditorGUILayout.SelectableLabel(guid);
            EditorGUILayout.SelectableLabel(id.ToString());
        }
}
