/*!
 * This file is part of OffloadBuddy.
 * COPYRIGHT (C) 2020 Emeric Grange - All Rights Reserved
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

#ifndef JOB_WORKER_SYNC_H
#define JOB_WORKER_SYNC_H
/* ************************************************************************** */

#include <QObject>
#include <QQueue>
#include <QMutex>

class QThread;
class Shot;
struct Job;

/* ************************************************************************** */

/*!
 * \brief The JobWorker class
 */
class JobWorkerSync: public QObject
{
    Q_OBJECT

    bool m_working = false;
    QQueue <Job *> m_jobs;
    QMutex m_jobsMutex;

public:
    JobWorkerSync();
    ~JobWorkerSync();

    QThread *thread = nullptr;

    bool isWorking();

public slots:
    void queueWork(Job *job);
    void work();

signals:
    void startWorking();

    void jobStarted(int);
    void jobProgress(int, float);
    void jobFinished(int, int);

    void shotStarted(int, Shot *);
    void shotFinished(int, Shot *);

    void fileProduced(QString);
};

/* ************************************************************************** */
#endif // JOB_WORKER_SYNC_H
