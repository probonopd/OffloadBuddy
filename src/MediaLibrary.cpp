/*!
 * This file is part of OffloadBuddy.
 * COPYRIGHT (C) 2018 Emeric Grange - All Rights Reserved
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * \date      2018
 * \author    Emeric Grange <emeric.grange@gmail.com>
 */

#include "MediaLibrary.h"
#include "SettingsManager.h"
#include "MediaDirectory.h"
#include "FileScanner.h"

#include <QThread>
#include <QDebug>

/* ************************************************************************** */

MediaLibrary::MediaLibrary()
{
    //
}

MediaLibrary::~MediaLibrary()
{
    //
}

/* ************************************************************************** */
/* ************************************************************************** */

void MediaLibrary::searchMediaDirectories()
{
    SettingsManager *s = SettingsManager::getInstance();
    if (s)
    {
        // TODO connect to directoriesUpdated()

        const QList <QObject *> * mediaDirectories = s->getDirectoriesList();

        for (auto d: *mediaDirectories)
        {
            MediaDirectory *dd = qobject_cast<MediaDirectory*>(d);

            //if (dd->isAvailable())
            {
                QThread *thread = new QThread();
                FileScanner *fs = new FileScanner();

                if (thread && fs)
                {
                    fs->chooseFilesystem(dd->getPath());
                    fs->moveToThread(thread);

                    connect(thread, SIGNAL(started()), fs, SLOT(scanFilesystem()));
                    connect(fs, SIGNAL(fileFound(ofb_file *, ofb_shot *)), m_shotModel, SLOT(addFile(ofb_file *, ofb_shot *)));
                    connect(fs, SIGNAL(scanningStarted(QString)), this, SLOT(workerScanningStarted(QString)));
                    connect(fs, SIGNAL(scanningFinished(QString)), this, SLOT(workerScanningFinished(QString)));

                    // automatically delete thread and everything when the work is done
                    connect(thread, SIGNAL(finished()), thread, SLOT(deleteLater()));
                    connect(fs, SIGNAL (scanningFinished(QString)), fs, SLOT (deleteLater()));
                    connect(fs, SIGNAL(scanningFinished(QString)), thread, SLOT(quit()));

                    thread->start();
                }
            }
        }
    }
}

/* ************************************************************************** */

void MediaLibrary::workerScanningStarted(QString s)
{
    qDebug() << "> MediaLibrary::workerScanningStarted(" << s << ")";
    m_libraryState = DEVICE_STATE_SCANNING;
    emit stateUpdated();
}

void MediaLibrary::workerScanningFinished(QString s)
{
    qDebug() << "> MediaLibrary::workerScanningFinished(" << s << ")";
    m_libraryState = DEVICE_STATE_IDLE;
    emit stateUpdated();
}