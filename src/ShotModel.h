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

#ifndef SHOT_MODEL_H
#define SHOT_MODEL_H
/* ************************************************************************** */

#include "Shot.h"

#include <QObject>
#include <QMetaType>
#include <QDateTime>
#include <QAbstractListModel>

/* ************************************************************************** */

class ShotModel : public QAbstractListModel
{
    Q_OBJECT
    Q_ENUMS(ShotRoles)

    QList<Shot *> m_shots;

protected:
    QHash<int, QByteArray> roleNames() const;

public:
    enum ShotRoles {
        NameRole = Qt::UserRole+1,
        ShotTypeRole,
        FileTypeRole,
        PreviewRole,
        SizeRole,
        DurationRole,
        DateRole,
        GpsRole,
        CameraRole,

        PointerRole,
        PathRole,
    };

    ShotModel(QObject *parent = nullptr);
    ShotModel(const ShotModel &other);
    ~ShotModel();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    void getShots(QList<Shot *> &shots);
    Shot *getShotAt(Shared::ShotType type, int file_id, int camera_id) const;
    Shot *getShotAtIndex(int index);
    Shot *getShotWithUuid(const QString &uuid);
    Shot *getShotWithName(const QString &name);
    Shot *getShotWithPath(const QString &path);

    Q_INVOKABLE qint64 getDiskSpace() const;
    Q_INVOKABLE int getShotCount() const;
    Q_INVOKABLE int getFileCount() const;

public slots:
    void addFile(ofb_file *f, ofb_shot *s);
    void addShot(Shot *shot);
    void removeShot(Shot *shot);
    void sanetize();
};

//Q_DECLARE_METATYPE(ShotModel*)

/* ************************************************************************** */
#endif // SHOT_MODEL_H
