package com.molihuan.hlbmerge.ui.screen.path.select.component

import android.os.Environment
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun FolderChooserDialog(
    onDirPathSelected: (String) -> Unit,
    onDismiss: () -> Unit
) {
    var currentDir by remember { mutableStateOf(Environment.getExternalStorageDirectory()) }
    var subDirs by remember { mutableStateOf(currentDir.listFiles()?.filter { it.isDirectory } ?: emptyList()) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(text = "选择文件夹") },
        text = {
            Column {
                Text(
                    text = "当前目录: ${currentDir.absolutePath}",
                    style = MaterialTheme.typography.bodySmall,
                    modifier = Modifier.padding(bottom = 8.dp)
                )

                LazyColumn(modifier = Modifier.height(300.dp)) {
                    if (currentDir.parentFile != null) {
                        item {
                            Text(
                                text = ".. (上一级)",
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clickable {
                                        currentDir = currentDir.parentFile!!
                                        subDirs = currentDir.listFiles()?.filter { it.isDirectory } ?: emptyList()
                                    }
                                    .padding(8.dp)
                            )
                        }
                    }

                    items(subDirs.size) { index ->
                        val dir = subDirs[index]
                        Text(
                            text = dir.name,
                            modifier = Modifier
                                .fillMaxWidth()
                                .clickable {
                                    currentDir = dir
                                    subDirs = dir.listFiles()?.filter { it.isDirectory } ?: emptyList()
                                }
                                .padding(8.dp)
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = { onDirPathSelected(currentDir.absolutePath) }) {
                Text("选择")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("取消")
            }
        }
    )
}